# manifold

A collection of 3D models designed for printing, authored in
[OpenSCAD](https://openscad.org/). Models are organised **by project** — a
coherent set of related models (e.g. a chess set: a board plus a piece for
each rank). Exported meshes (`.stl`, `.3mf`, …) are treated as build artifacts
and are **not** committed — they are regenerated from the `.scad` sources.

## Working with a model

Render or export with the OpenSCAD CLI:

```sh
# Preview / open in the GUI
openscad projects/chess/models/board/cell.scad

# Export a printable mesh into the project's exports/ (output is gitignored),
# named <model>-<part>.<ext>
openscad -o projects/chess/exports/board-cell.stl projects/chess/models/board/cell.scad
```

## Adding a new model

1. Create `projects/<project>/models/<model>/` (add a new project folder — with
   its `README.md` — if needed; `exports/` appears on the first export).
2. Add one `.scad` file per printed part, with tunable parameters at the top.
   Put geometry shared between the parts in another `.scad` file in the folder,
   or in the project's `lib/` if it's shared across models.
3. Document the model in the project `README.md` (parts, parameters, and
   recommended print settings — layer height, infill, supports, orientation).
4. Commit the `.scad` sources and docs — exported meshes stay local in
   `exports/`.

## License

The catalog itself — the repository structure, tooling, and documentation — is
licensed under the [MIT License](LICENSE).

**Each project sets its own license**, in a `LICENSE` file in the project
directory, and that license governs the models in it.
