#!/usr/bin/env python3
"""Merge managed Windows Terminal settings into the live settings.json.

Windows Terminal auto-generates profiles (WSL distros, PowerShell, Git Bash,
Azure) and records every GUID it generates in state.json. If a generated
profile is *absent* from settings.json, WT treats it as user-deleted and will
not recreate it (a "tombstone"). Overwriting the whole file therefore wipes the
generated profiles and tombstones them. So we MERGE our managed keys into the
existing file instead, preserving the generated profile list.

The managed fragment re-adds the Debian profile under the GUID WT's own WSL
generator uses: UUIDv5 of the UTF-16LE distro name in the namespace
{2bde4a90-d05f-401c-9492-e40884ead1d8}. That is the same on every machine, so WT
adopts our stub as the real Debian profile (no duplicate) and, because the GUID
is now present in settings.json, stops tombstoning the generated one.

Usage: merge_settings.py <managed.json> <live-settings.json>
Prints CHANGED or UNCHANGED.
"""
import json
import os
import re
import shutil
import sys


def strip_jsonc(text):
    """Remove // and /* */ comments and trailing commas, respecting strings."""
    out = []
    i, n = 0, len(text)
    in_string = False
    while i < n:
        char = text[i]
        if in_string:
            out.append(char)
            if char == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 2
                continue
            if char == '"':
                in_string = False
            i += 1
            continue
        if char == '"':
            in_string = True
            out.append(char)
            i += 1
            continue
        if char == "/" and i + 1 < n and text[i + 1] == "/":
            i += 2
            while i < n and text[i] != "\n":
                i += 1
            continue
        if char == "/" and i + 1 < n and text[i + 1] == "*":
            i += 2
            while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(char)
        i += 1
    return re.sub(r",(\s*[}\]])", r"\1", "".join(out))


def load_jsonc(path):
    if not os.path.exists(path) or os.path.getsize(path) == 0:
        return {}
    text = open(path, encoding="utf-8-sig").read()
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return json.loads(strip_jsonc(text))


def merge_by_key(existing, incoming, key):
    """Union two lists of dicts on a key; incoming wins on a match."""
    result = list(existing)
    index = {item.get(key): i for i, item in enumerate(result) if isinstance(item, dict)}
    for item in incoming:
        ident = item.get(key) if isinstance(item, dict) else None
        if ident in index:
            deep_merge(result[index[ident]], item)
        else:
            index[ident] = len(result)
            result.append(item)
    return result


def deep_merge(base, overlay):
    for key, value in overlay.items():
        if key == "schemes" and isinstance(value, list):
            base[key] = merge_by_key(base.get(key, []), value, "name")
        elif key == "list" and isinstance(value, list):
            base[key] = merge_by_key(base.get(key, []), value, "guid")
        elif isinstance(value, dict) and isinstance(base.get(key), dict):
            deep_merge(base[key], value)
        else:
            base[key] = value
    return base


def main():
    managed_path, live_path = sys.argv[1], sys.argv[2]
    managed = load_jsonc(managed_path)
    live = load_jsonc(live_path)

    before = json.dumps(live, sort_keys=True)
    merged = deep_merge(live, managed)
    if json.dumps(merged, sort_keys=True) == before:
        print("UNCHANGED")
        return

    if os.path.exists(live_path):
        shutil.copy2(live_path, live_path + ".ansible.bak")
    else:
        os.makedirs(os.path.dirname(live_path), exist_ok=True)
    with open(live_path, "w", encoding="utf-8") as handle:
        json.dump(merged, handle, indent=4)
        handle.write("\n")
    print("CHANGED")


if __name__ == "__main__":
    main()
