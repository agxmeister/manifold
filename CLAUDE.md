# CLAUDE.md

Guidance for AI agents working in this repository.

## What this repo is

`manifold` is a collection of 3D-printable models authored in
[OpenSCAD](https://openscad.org/) (`.scad`). Sources are versioned; exported
meshes are not (see `.gitignore`).

## Structure & naming

- **One folder per model** under `models/`, named in `kebab-case`.
- The primary source file matches the folder name: `models/foo/foo.scad`.
- Each model folder carries its own `README.md` (part description, tunable
  parameters, recommended print settings).
- Shared, reusable geometry goes in `lib/` and is pulled into models with
  `use <../../lib/...>` or `include <...>`.

## Authoring conventions

- Keep models **parametric**: expose sizes as named variables at the top of the
  `.scad` file rather than hard-coding magic numbers.
- Design for printability — flat contact area on the bed, self-supporting
  overhangs, avoid needing supports where geometry can be reworked instead.
- Prefer clear, commented module boundaries over one monolithic block.

## Exports are build output

- `.stl`, `.3mf`, and other generated formats are gitignored. Never commit them.
- Regenerate a mesh from source, e.g.
  `openscad -o out.stl models/<name>/<name>.scad`.

## Working here

- When creating or editing models for print, use the `openscad-3d-print-design`
  skill and the loom MCP tools (validate / render / export) for visual QA before
  considering a model done.
- Do not commit or push unless explicitly asked.
