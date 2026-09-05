#!/usr/bin/env python3
"""
vault-audit.py — health check for the vault: frontmatter schema, broken wikilinks,
duplicate basenames. Read-only. Prints a report and exits non-zero if --strict and
any error is found (used by CI in report mode by default).

Usage:
  vault-audit.py [--root ~/Vault] [--strict] [--json]
"""
import os, re, sys, json, argparse, datetime

REQUIRED = ["title", "type", "status", "created", "updated"]
TYPES = {"project","client","technology","business","learning","idea","research",
         "career","life","resource","moc","note",
         "reference","spec","plan","log"}   # doc types used in 4-Tools / resources
# core lifecycle + career/opportunity pipeline vocabulary (3-Garden/career tracks applications)
STATUSES = {"active","paused","done","evergreen","seed",
            "radar","new","applied","negotiating","offer","rejected","discarded",
            "archived","inactive","approved"}
# files whose bodies contain [[example]] link syntax — exempt from broken-link checks
LINK_EXEMPT_FILES = {"conventions.md","tagging.md","AGENTS.md","CLAUDE.md","GEMINI.md",
                     "frontmatter-spec.md","Vault visibility policy.md","Obsidian.md",
                     "obsidian-markdown.md","graph-hygiene.md"}
# paths exempt from broken-link checks (archives, overrides)
LINK_EXEMPT_PREFIX = ("4-Tools/state-history/", "4-Tools/team-overrides/", "0-Inbox/")
# class 3 FEATURE per graph-hygiene.md §3 — lien creux vers vrai concept futur, on garde
# Ne pas créer de stub vide juste pour faire propre ; ces cibles sont whitelistées
CLASS3_FUTURE = {"NestJS","GSAP","Laravel Forge","Dify","Tauri","TypeScript","SQLite","Ollama","Stitch","LangGraph","CrewAI","Tailwind CSS v4","keelwork","ops-autopilot","weave-secrets","Payload-CMS","Island Guide AI","blueowl","Embark","wikilinks","Leverage Engine","natural-speech-MOC","Evidence wins - contract arbitration"}
# basenames that legitimately exist in multiple folders
DUP_OK = {"README","AGENTS","Ideas-MOC","echotravel-vps-ops"}
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
LINK_RE = re.compile(r"\[\[([^\]]+)\]\]")
# folders never walked at all
SKIP_DIRS = {".git", ".obsidian", ".github", ".cursor", "graphify-out", "node_modules"}
# zone machine : executable du socle, entierement hors audit de notes
# (schema, liens ET espace de noms des basenames). Obsidian l'ignore deja.
MACHINE_ZONE_PREFIX = ("4-Tools/skills/", "4-Tools/mcp/", "4-Tools/bin/", "4-Tools/hosts/")
# paths still indexed for link resolution but EXEMPT from schema checks:
# - 4-Tools/state-history = instantanes archives de current-state.md (meme forme memoire)
# - 4-Tools/memory = claude-mem auto-memory (name/description/metadata shape; own loader)
# - 0-Home/Roadmap = roadmap-skill output (own roadmap-week/-month types, regenerated)
# - 0-Inbox = transient capture staging, promoted into curated notes later (not curated yet)
# - root meta files are not vault notes
# Rule: machine output is not held to the human note schema (see 4-Tools/graph-hygiene.md).
SCHEMA_EXEMPT_PREFIX = ("4-Tools/templates/",
                        "4-Tools/memory/", "4-Tools/state-history/",
                        "0-Home/Roadmap/", "0-Inbox/")
SCHEMA_EXEMPT_FILES = {"README.md","AGENTS.md","CLAUDE.md","GEMINI.md"}
# external artifacts pasted verbatim (recon/pentest/disclosure/bounty, cover letters) — not curated notes
SCHEMA_EXEMPT_RE = re.compile(
    r"(recon|pentest|disclosure|bounty|takeover|PII-Exposure|Lettre motivation)", re.I)

def schema_exempt(rel):
    return (rel.startswith(SCHEMA_EXEMPT_PREFIX)
            or rel in SCHEMA_EXEMPT_FILES
            or os.path.basename(rel) == "README.md"
            or SCHEMA_EXEMPT_RE.search(rel) is not None)

def _scan_links(rel, body, basenames, link_issues):
    if os.path.basename(rel) in LINK_EXEMPT_FILES:
        return
    if rel.startswith(LINK_EXEMPT_PREFIX):
        return
    # ignorer les liens dans le code : inline `...` et blocs ```...``` / ~~~
    body_nocode = re.sub(r'```.*?```', '', body, flags=re.DOTALL)
    body_nocode = re.sub(r'~~~.*?~~~', '', body_nocode, flags=re.DOTALL)
    body_nocode = re.sub(r'`[^`]*`', '', body_nocode)
    for m in LINK_RE.finditer(body_nocode):
        target = m.group(1).split("|")[0].split("#")[0].strip()
        if not target:
            continue
        if target in CLASS3_FUTURE:
            continue
        # alias populaire : [[blueowl]] -> 1-Projects/blueowl/blueowl-website.md
        if target == "blueowl" and "blueowl-website" in basenames:
            continue
        # resolve by basename, or by last path component for path-style links
        if target in basenames or target.split("/")[-1] in basenames:
            continue
        link_issues.append((rel, target))

def parse_frontmatter(text):
    if not text.startswith("---"):
        return None, text
    end = text.find("\n---", 3)
    if end == -1:
        return None, text
    fm = text[3:end].strip("\n")
    body = text[end+4:]
    data = {}
    for line in fm.splitlines():
        m = re.match(r"^([A-Za-z_]+):\s*(.*)$", line)
        if m:
            data[m.group(1)] = m.group(2).strip()
    return data, body

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=os.path.expanduser("~/Vault"))
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--json", action="store_true")
    args = ap.parse_args()
    root = args.root

    files = []
    for dp, dns, fns in os.walk(root):
        dns[:] = [d for d in dns if d not in SKIP_DIRS]
        for fn in fns:
            if not fn.endswith(".md") or fn.startswith("."):
                continue
            f = os.path.join(dp, fn)
            if os.path.relpath(f, root).startswith(MACHINE_ZONE_PREFIX):
                continue
            files.append(f)

    basenames = {}          # stem -> [paths]
    for f in files:
        stem = os.path.splitext(os.path.basename(f))[0]
        basenames.setdefault(stem, []).append(f)
        # Obsidian resolves a wikilink by filename OR by any declared alias.
        # Without this, a legitimate `aliases:` entry reads as a broken link.
        try:
            head = open(f, encoding="utf-8").read(2000)
        except Exception:
            continue
        m = re.search(r'^aliases:\s*\[(.*?)\]\s*$', head, re.M)
        if m:
            for a in re.findall(r'"([^"]+)"|\'([^\']+)\'', m.group(1)):
                alias = a[0] or a[1]
                if alias:
                    basenames.setdefault(alias, []).append(f)

    schema_issues, link_issues = [], []
    for f in files:
        rel = os.path.relpath(f, root)
        try:
            text = open(f, encoding="utf-8").read()
        except Exception as e:
            schema_issues.append((rel, f"unreadable: {e}")); continue
        fm, body = parse_frontmatter(text)
        if schema_exempt(rel):
            # still scan its body for broken links below, but skip schema checks
            fm = fm or {}
            _scan_links(rel, body, basenames, link_issues)
            continue
        if fm is None:
            schema_issues.append((rel, "no frontmatter")); continue
        for k in REQUIRED:
            if k not in fm or fm[k] == "":
                schema_issues.append((rel, f"missing '{k}'"))
        if fm.get("type") and fm["type"] not in TYPES:
            schema_issues.append((rel, f"bad type '{fm['type']}'"))
        if fm.get("status") and fm["status"] not in STATUSES:
            schema_issues.append((rel, f"bad status '{fm['status']}'"))
        for k in ("created","updated"):
            if fm.get(k) and not DATE_RE.match(fm[k]):
                schema_issues.append((rel, f"bad date {k}='{fm[k]}'"))
        # broken wikilinks (resolve by basename, Obsidian-style)
        _scan_links(rel, body, basenames, link_issues)

    dups = {k:v for k,v in basenames.items()
            if len(v) > 1 and k not in DUP_OK
            and not all("team-overrides" in p for p in v[1:])}

    if args.json:
        print(json.dumps({
            "files": len(files),
            "schema_issues": schema_issues,
            "broken_links": link_issues,
            "duplicate_basenames": dups,
        }, indent=2, ensure_ascii=False))
    else:
        print(f"Vault audit — {len(files)} notes under {root}\n")
        print(f"## Schema issues: {len(schema_issues)}")
        for rel, msg in schema_issues[:80]:
            print(f"  - {rel}: {msg}")
        if len(schema_issues) > 80: print(f"  … +{len(schema_issues)-80} more")
        print(f"\n## Broken wikilinks: {len(link_issues)}")
        seen=set()
        for rel, tgt in link_issues:
            key=(rel,tgt)
            if key in seen: continue
            seen.add(key)
            print(f"  - {rel} → [[{tgt}]]")
        print(f"\n## Duplicate basenames: {len(dups)}")
        for stem, paths in sorted(dups.items()):
            print(f"  - {stem}: " + " | ".join(os.path.relpath(p, root) for p in paths))

    total = len(schema_issues) + len(link_issues) + len(dups)
    if args.strict and total:
        sys.exit(1)

if __name__ == "__main__":
    main()
