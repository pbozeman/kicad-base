set shell := ["sh", "-eu", "-c"]

nix := "nix --extra-experimental-features 'nix-command flakes'"

default:
  @just --list

help:
  @just --list

# Run the template-sync check plus the full pre-commit hook suite.
check *args: check-template
  {{ nix }} develop -c pre-commit run --all-files {{ args }}

# template/root is canonical for files this repo also keeps at its own root.
check-template:
  @diff -q template/root/.gitignore .gitignore >/dev/null \
    || { echo "stale: .gitignore differs from template/root/.gitignore"; exit 1; }

# Flow: mkdir foo && cd foo && git init
#        git submodule add <kicad-base-url> kicad-base
#        cd kicad-base && nix develop -c just setup           (single-board repo)
#        cd kicad-base && nix develop -c just setup <board>   (first board of a multi-board repo)
# Scaffold a new project (dotfiles + first board) in the parent directory.
setup name="" stackup="jlcpcb-6layer":
  #!/usr/bin/env sh
  set -eu
  [ -e ../.git ] \
    || { echo "parent is not a git repo; run from kicad-base/ inside a 'git init'-ed project"; exit 1; }
  [ ! -e ../Justfile ] \
    || { echo "../Justfile already exists; project appears set up (use 'just sync' from the project root)"; exit 1; }
  [ ! -e ../templates ] \
    || { echo "refusing: parent looks like kicad-base itself"; exit 1; }
  cp -R template/root/. ..
  # .envrc is untracked by convention (globally git-ignored), so generate it.
  [ -e ../.envrc ] || echo 'use flake ./kicad-base' >../.envrc
  cd ..
  just new-board '{{ name }}' '{{ stackup }}'
  if command -v pre-commit >/dev/null; then
    pre-commit install >/dev/null
  else
    echo "note: run 'pre-commit install' from the project root inside the dev shell"
  fi
  echo "project scaffolded; next: direnv allow (or 'nix develop ./kicad-base')"
