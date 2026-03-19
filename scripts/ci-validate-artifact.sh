#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACT_DIR="${SOURCEMOD_ARTIFACT_DIR:-$ROOT_DIR/dist/sourcemod/artifact}"

if [[ ! -d "$ARTIFACT_DIR" ]]; then
  echo "SourceMod artifact directory not found at $ARTIFACT_DIR" >&2
  exit 1
fi

python3 - "$ROOT_DIR" "$ARTIFACT_DIR" <<'PY'
import bz2
import os
import sys

root_dir, artifact_dir = sys.argv[1], sys.argv[2]

plugin_path = os.path.join(artifact_dir, "addons", "sourcemod", "plugins", "vip", "fortnite_emotes_extended.smx")
root_plugin_path = os.path.join(artifact_dir, "addons", "sourcemod", "plugins", "fortnite_emotes_extended.smx")
include_dir = os.path.join(artifact_dir, "addons", "sourcemod", "scripting", "include")

if not os.path.isfile(plugin_path):
    raise SystemExit(f"Missing compiled plugin: {plugin_path}")

if os.path.exists(root_plugin_path):
    raise SystemExit(f"Plugin should not exist at root plugins directory: {root_plugin_path}")

include_entries = sorted(entry for entry in os.listdir(include_dir) if os.path.isfile(os.path.join(include_dir, entry)))
if include_entries != ["fnemotes.inc"]:
    raise SystemExit(f"Unexpected public includes: {include_entries}")

for relative_root in ("models", "sound"):
    source_root = os.path.join(root_dir, relative_root)
    packaged_root = os.path.join(artifact_dir, relative_root)

    for current_root, dirs, files in os.walk(source_root):
        dirs.sort()
        files.sort()
        relative_path = os.path.relpath(current_root, source_root)
        packaged_dir = packaged_root if relative_path == "." else os.path.join(packaged_root, relative_path)

        for file_name in files:
            source_path = os.path.join(current_root, file_name)
            packaged_path = os.path.join(packaged_dir, file_name)
            compressed_path = packaged_path + ".bz2"

            if not os.path.isfile(packaged_path):
                raise SystemExit(f"Missing packaged asset: {packaged_path}")

            if not os.path.isfile(compressed_path):
                raise SystemExit(f"Missing bz2 sidecar: {compressed_path}")

            with open(source_path, "rb") as source_handle:
                source_payload = source_handle.read()

            with open(packaged_path, "rb") as packaged_handle:
                packaged_payload = packaged_handle.read()

            if packaged_payload != source_payload:
                raise SystemExit(f"Packaged asset differs from source: {packaged_path}")

            with open(compressed_path, "rb") as compressed_handle:
                compressed_payload = compressed_handle.read()

            if bz2.decompress(compressed_payload) != source_payload:
                raise SystemExit(f"Compressed asset does not decompress to original payload: {compressed_path}")

print("ARTIFACT_VALIDATION_OK")
PY