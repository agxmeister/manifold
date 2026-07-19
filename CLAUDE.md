# CLAUDE.md

Guidance for AI agents working in this repository.

## What this repo is

`manifold` is a collection of 3D-printable models authored in
[OpenSCAD](https://openscad.org/) (`.scad`). Sources are versioned; exported
meshes are not (see `.gitignore`).

## Structure & naming

Models are organised **by project** under `projects/`, everything in
`kebab-case`. Each project has a strict internal layout:

```
projects/<project>/
├── README.md      # the ONLY README — documents the project's models,
│                  #   parts, parameters, and print settings
├── LICENSE        # the project's own license, governing its models
├── models/        # one subdirectory per model
│   └── <model>/       # a model is a folder; its parts are .scad files
│       ├── <part>.scad    #   one file per separately-printed part
│       └── <shared>.scad  #   geometry shared between this model's parts
├── lib/           # geometry shared ACROSS the project's models (e.g. a
│                  #   common figure base); omit until something needs it
├── exports/       # generated meshes land here — created on first export,
│                  #   gitignored in full, never committed
└── previews/      # generated .png previews land here — same hierarchy as
                   #   exports/, created on first render, gitignored, never committed
```

- A **model is a folder** under `models/`; its **parts are `.scad` files**
  inside it. A single-part model has one file matching the folder name
  (`models/pawn/pawn.scad`); a multi-part model has one file per
  separately-printed part (`models/board/cell.scad`, `models/board/pin.scad`).
- A **README lives only at the project level**. Don't add per-model or
  per-part READMEs.
- Geometry shared between a model's own parts is another `.scad` file in that
  model's folder (e.g. `models/board/connector.scad`); geometry shared across
  models goes in the project's `lib/`. There is no top-level cross-project
  `lib/`. Pull shared files in with `include <...>` or `use <...>`.
- **Exports go in the project's `exports/` directory**, named
  `<model>-<part>.<ext>` — e.g. `board-cell.stl`, `board-pin.stl`. Append a
  variant suffix where a part has several (`board-cell-d2.stl` for `design=2`).
  The whole `exports/` directory is gitignored build output — it's created on
  the first export and never committed.
- **Previews go in the project's `previews/` directory**, a `.png` sibling of
  `exports/` with the same naming — `<model>-<part>.png` (e.g.
  `board-cell.png`), same variant suffixes. Like `exports/`, the whole
  `previews/` directory is gitignored build output, created on the first render
  and never committed.
- **Licensing is per project.** The catalog root is MIT (`LICENSE` at the repo
  root); each project carries its own `LICENSE` file governing its models
  (e.g. `projects/chess/LICENSE` is CC BY-NC 4.0). A new project needs its own
  `LICENSE` — ask the user which license if it isn't obvious.

## Authoring conventions

- Keep models **parametric**: expose sizes as named variables at the top of the
  `.scad` file rather than hard-coding magic numbers.
- Design for printability — flat contact area on the bed, self-supporting
  overhangs, avoid needing supports where geometry can be reworked instead.
- Prefer clear, commented module boundaries over one monolithic block.

## Exports are build output

- `.stl`, `.3mf`, and other generated formats are gitignored. Never commit them.
- Regenerate a mesh from source into the project's `exports/`, named
  `<model>-<part>.<ext>`, e.g.
  `openscad -o projects/chess/exports/board-cell.stl projects/chess/models/board/cell.scad`.

## Working here

- When creating or editing models for print, use the `openscad-3d-print-design`
  skill and the loom MCP tools (validate / render / export) for visual QA before
  considering a model done.
- Do not commit or push unless explicitly asked.
