#!/usr/bin/env bash

set -euo pipefail

tag_name="${1:-}"

if [[ -z "$tag_name" ]]; then
  echo "Usage: $0 <tag-name>" >&2
  exit 1
fi

if [[ "$tag_name" != sourcemod/v* ]]; then
  echo "Unsupported release tag: $tag_name" >&2
  exit 1
fi

version="${tag_name#sourcemod/v}"

if [[ -z "$version" ]]; then
  echo "Could not resolve release version from tag: $tag_name" >&2
  exit 1
fi

release_name="SourceMod ${version}"
prerelease=false

if [[ "$version" == *-* ]]; then
  prerelease=true
fi

{
  echo "component=fortnite-emotes-extended"
  echo "version=$version"
  echo "release_name=$release_name"
  echo "prerelease=$prerelease"
}