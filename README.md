# kicad-base

Shared base for my KiCad board projects: common symbol libraries, fab docs,
board stackup templates, and the tooling skeleton for new project repos.

Projects consume this repo as a git submodule at `kicad-base/`. That submodule
is the single distribution channel: the pinned rev controls the parts
libraries, the dev shell, the shared recipes, and the canonical copies of the
project dotfiles.

## Layout

- `lib/`, `sym-lib-table` — shared symbol libraries and the canonical per-board
  lib table (published in from kicad-parts)
- `docs/` — fab notes (JLCPCB stackups, impedance, etc.)
- `templates/` — board stackup templates (`jlcpcb-6layer`, `jlcpcb-8layer`)
- `template/root/` — project skeleton, copied into new projects by `setup` and
  refreshed by `sync`
- `just/project.just` — shared recipes imported by each project's Justfile
- `flake.nix` — dev shell (formatters, pre-commit, just); projects reuse it via
  `.envrc` → `use flake ./kicad-base`, so no per-project flake is needed.
  `.envrc` is untracked by convention (globally git-ignored): `setup` generates
  it, and on a fresh clone recreate it with
  `echo 'use flake ./kicad-base' > .envrc`

## New project

```sh
mkdir foo && cd foo && git init
git submodule add <kicad-base-url> kicad-base
cd kicad-base && nix develop -c just setup            # single-board repo
cd kicad-base && nix develop -c just setup mainboard  # or: first board of a multi-board repo
```

`setup` copies the skeleton from `template/root/` into the project root and
creates the first board. Then `direnv allow` in the project root and you're in
the dev shell.

## Board layout

Boards live under `pcb/`. A single-board repo keeps the files directly in
`pcb/`; a multi-board repo uses one subdirectory per board:

```
single:                          multi:
  kicad-base/                      kicad-base/
  pcb/                             pcb/
    base -> ../kicad-base            mainboard/
    foo.kicad_pro ...                  base -> ../../kicad-base
    sym-lib-table                      mainboard.kicad_pro ...
                                       sym-lib-table
```

Every board dir has a committed `base` symlink to the submodule, so the
`sym-lib-table` is the same verbatim file everywhere
(`${KIPRJMOD}/base/lib/...`) regardless of depth, and matches what kicad-parts
publishes. Add boards with `just new-board <name>`.

## Project recipes

From the project root (imported from `kicad-base/just/project.just`):

- `just check` — drift check plus the pre-commit suite (what CI runs)
- `just sync` — refresh the managed files from the pinned `kicad-base/` rev
- `just new-board [name] [stackup]` — add a board

Managed files (`.gitignore`, `.pre-commit-config.yaml`, the `ci` workflow, and
each board's `sym-lib-table`) are verbatim copies owned by kicad-base — don't
edit them in a project; change them here and `sync`. The project's `Justfile`
is seeded once and then owned by the project, as is any additional workflow
file beside the managed `ci.yml`.

## Updating a project

```sh
git -C kicad-base pull      # or: git submodule update --remote kicad-base
just sync
git add -A && git commit
```

If you bump the submodule and forget to sync, `just check` (and CI) fails with
a list of stale files.
