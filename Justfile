set shell := ["sh", "-eu", "-c"]

nix := "nix --extra-experimental-features 'nix-command flakes'"

default:
  @just --list

help:
  @just --list

# Run the full pre-commit hook suite (formatters and linters).
check *args:
  {{ nix }} develop -c pre-commit run --all-files {{ args }}
