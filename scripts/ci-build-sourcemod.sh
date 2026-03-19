#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${RUNNER_TEMP:-$ROOT_DIR/.tmp}/sourcemod-build"
DIST_DIR="$ROOT_DIR/dist/sourcemod"
ARTIFACT_DIR="$DIST_DIR/artifact"
SOURCEMOD_ARCHIVE_URL="${SOURCEMOD_ARCHIVE_URL:?SOURCEMOD_ARCHIVE_URL is required}"

rm -rf "$WORK_DIR" "$DIST_DIR"
mkdir -p "$WORK_DIR" "$ARTIFACT_DIR"

echo "Downloading SourceMod compiler package..."
curl -fsSL "$SOURCEMOD_ARCHIVE_URL" -o "$WORK_DIR/sourcemod.tar.gz"
tar -xzf "$WORK_DIR/sourcemod.tar.gz" -C "$WORK_DIR"

SOURCEMOD_DIR="$WORK_DIR"
SPCOMP_BIN="$SOURCEMOD_DIR/addons/sourcemod/scripting/spcomp"
SOURCEMOD_INCLUDE_DIR="$SOURCEMOD_DIR/addons/sourcemod/scripting/include"
LOCAL_INCLUDE_DIR="$ROOT_DIR/addons/sourcemod/scripting/include"
PACKAGE_SM_DIR="$ARTIFACT_DIR/addons/sourcemod"
PACKAGE_PLUGIN_DIR="$PACKAGE_SM_DIR/plugins/vip"
PACKAGE_SCRIPTING_DIR="$PACKAGE_SM_DIR/scripting"
PACKAGE_INCLUDE_DIR="$PACKAGE_SCRIPTING_DIR/include"
PACKAGE_DATA_DIR="$PACKAGE_SM_DIR/data"
PACKAGE_TRANSLATIONS_DIR="$PACKAGE_SM_DIR/translations"
PACKAGE_CFG_DIR="$ARTIFACT_DIR/cfg/sourcemod"
COMPILE_LOG="$ARTIFACT_DIR/compile.log"

mkdir -p \
  "$PACKAGE_PLUGIN_DIR" \
  "$PACKAGE_SCRIPTING_DIR" \
  "$PACKAGE_INCLUDE_DIR" \
  "$PACKAGE_DATA_DIR" \
  "$PACKAGE_TRANSLATIONS_DIR" \
  "$PACKAGE_CFG_DIR"

: > "$COMPILE_LOG"

compile_plugin() {
  local source_file="$1"
  local output_file="$2"

  echo "Compiling $(basename "$source_file")..."
  "$SPCOMP_BIN" \
    "$source_file" \
    -i"$LOCAL_INCLUDE_DIR" \
    -i"$SOURCEMOD_INCLUDE_DIR" \
    -o"$output_file" \
    2>&1 | tee -a "$COMPILE_LOG"
}

copy_tree_with_bz2_sidecars() {
  local source_root="$1"
  local target_root="$2"

  if [[ ! -d "$source_root" ]]; then
    return 0
  fi

  python3 - "$source_root" "$target_root" <<'PY'
import bz2
import os
import shutil
import sys

source_root, target_root = sys.argv[1], sys.argv[2]

for current_root, dirs, files in os.walk(source_root):
    dirs.sort()
    files.sort()
    relative_root = os.path.relpath(current_root, source_root)
    destination_root = target_root if relative_root == "." else os.path.join(target_root, relative_root)
    os.makedirs(destination_root, exist_ok=True)

    for file_name in files:
        source_path = os.path.join(current_root, file_name)
        destination_path = os.path.join(destination_root, file_name)

        shutil.copy2(source_path, destination_path)

        with open(source_path, "rb") as source_handle:
            payload = source_handle.read()

        with open(destination_path + ".bz2", "wb") as compressed_handle:
            compressed_handle.write(bz2.compress(payload, compresslevel=9))
PY
}

compile_plugin \
  "$ROOT_DIR/addons/sourcemod/scripting/fortnite_emotes_extended.sp" \
  "$PACKAGE_PLUGIN_DIR/fortnite_emotes_extended.smx"

if [[ ! -f "$PACKAGE_PLUGIN_DIR/fortnite_emotes_extended.smx" ]]; then
  echo "Compiled plugin was not generated: fortnite_emotes_extended.smx" >&2
  exit 1
fi

cp "$ROOT_DIR/addons/sourcemod/scripting/fortnite_emotes_extended.sp" "$PACKAGE_SCRIPTING_DIR/"
cp -R "$ROOT_DIR/addons/sourcemod/scripting/fnemotes" "$PACKAGE_SCRIPTING_DIR/"
cp "$ROOT_DIR/addons/sourcemod/scripting/include/fnemotes.inc" "$PACKAGE_INCLUDE_DIR/"

cp -R "$ROOT_DIR/addons/sourcemod/data/fnemotes" "$PACKAGE_DATA_DIR/"
cp -R "$ROOT_DIR/addons/sourcemod/translations/." "$PACKAGE_TRANSLATIONS_DIR/"
cp "$ROOT_DIR/cfg/sourcemod/fortnite_emotes_extended.cfg" "$PACKAGE_CFG_DIR/"

copy_tree_with_bz2_sidecars "$ROOT_DIR/models" "$ARTIFACT_DIR/models"
copy_tree_with_bz2_sidecars "$ROOT_DIR/sound" "$ARTIFACT_DIR/sound"

echo "SourceMod artifacts generated in $ARTIFACT_DIR"