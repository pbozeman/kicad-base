# Shared recipes for projects that consume kicad-base as a submodule at
# kicad-base/. Imported by the project's root Justfile:
#
#   import 'kicad-base/just/project.just'
#
# Recipes run with the project root as the working directory. Each board dir
# holds a `base` symlink to the submodule, which keeps the sym-lib-table paths
# (${KIPRJMOD}/base/lib/...) identical at any depth.

set shell := ["sh", "-eu", "-c"]

nix := "nix --extra-experimental-features 'nix-command flakes'"

# Files copied verbatim from kicad-base/template/root and kept current by
# `sync`. The project Justfile is seeded once by `setup` but owned by the
# project.
managed := ".gitignore .pre-commit-config.yaml .forgejo/workflows/ci.yml"

# List board dirs: any dir holding a .kicad_pro, excluding the submodule and
# KiCad junk.
_find_boards := "find . \\( -path ./kicad-base -o -name '_autosave*' -o -name '*-backups' \\) -prune -o -name '*.kicad_pro' -print | while read -r f; do dirname \"$f\"; done | sort -u"

default:
  @just --list

help:
  @just --list

# Run the drift check plus the full pre-commit hook suite.
check *args: check-drift
  {{ nix }} develop ./kicad-base -c pre-commit run --all-files {{ args }}

# Refresh managed files (root dotfiles, CI workflow, board sym-lib-tables) from kicad-base/.
sync:
  #!/usr/bin/env sh
  set -eu
  for f in {{ managed }}; do
    mkdir -p "$(dirname "$f")"
    cp "kicad-base/template/root/$f" "$f"
  done
  for d in $({{ _find_boards }}); do
    cp kicad-base/sym-lib-table "$d/sym-lib-table"
  done

# Fail if any managed file has drifted from the pinned kicad-base/ revision.
check-drift:
  #!/usr/bin/env sh
  set -eu
  fail=0
  for f in {{ managed }}; do
    diff -q "kicad-base/template/root/$f" "$f" >/dev/null 2>&1 \
      || { echo "stale: $f (run 'just sync')"; fail=1; }
  done
  for d in $({{ _find_boards }}); do
    diff -q kicad-base/sym-lib-table "$d/sym-lib-table" >/dev/null 2>&1 \
      || { echo "stale: $d/sym-lib-table (run 'just sync')"; fail=1; }
    [ "$(realpath -m "$d/base" 2>/dev/null || true)" = "$(realpath ./kicad-base)" ] \
      || { echo "bad or missing symlink: $d/base (should resolve to ./kicad-base)"; fail=1; }
  done
  exit $fail

# Bare: single-board repo, files in pcb/, named after the repo dir. With a
# name: multi-board repo, files in pcb/<name>/.
# Create a board from a stackup template in kicad-base/templates/.
new-board name="" stackup="jlcpcb-6layer":
  #!/usr/bin/env sh
  set -eu
  name='{{ name }}'
  stackup='{{ stackup }}'
  [ -d "kicad-base/templates/$stackup" ] \
    || { echo "unknown stackup '$stackup' (available: $(ls kicad-base/templates | tr '\n' ' '))"; exit 1; }
  if [ -z "$name" ]; then
    dir=pcb
    board="$(basename "$(pwd)")"
    link_target=../kicad-base
    if [ -d pcb ] && find pcb -mindepth 1 -maxdepth 2 -name '*.kicad_pro' | grep -q .; then
      echo "pcb/ already contains a board; use 'just new-board <name>' to add another"
      exit 1
    fi
  else
    dir="pcb/$name"
    board="$name"
    link_target=../../kicad-base
    if [ -d pcb ] && find pcb -mindepth 1 -maxdepth 1 -name '*.kicad_pro' | grep -q .; then
      echo "single-board layout detected in pcb/; migrate before adding a named board:"
      echo "  mkdir pcb/<old>; git mv pcb/*.kicad_* pcb/sym-lib-table pcb/<old>/"
      echo "  ln -sfn ../../kicad-base pcb/<old>/base; rm pcb/base; just sync"
      exit 1
    fi
    [ ! -e "$dir" ] || { echo "$dir already exists"; exit 1; }
  fi
  echo "$board" | grep -Eq '^[A-Za-z0-9._-]+$' \
    || { echo "board name '$board' has unsupported characters (allowed: [A-Za-z0-9._-]; pass a name explicitly)"; exit 1; }
  mkdir -p "$dir"
  [ -e "$dir/base" ] || ln -s "$link_target" "$dir/base"
  for f in "kicad-base/templates/$stackup/$stackup".*; do
    ext="${f##*.}"
    sed "s/$stackup/$board/g" "$f" >"$dir/$board.$ext"
  done
  cp kicad-base/sym-lib-table "$dir/sym-lib-table"
  echo "created $dir/$board ($stackup)"
