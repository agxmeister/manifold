# manifold

A collection of 3D models designed for printing, authored in
[OpenSCAD](https://openscad.org/). Each model lives in its own self-contained
folder with its source, documentation, and print notes. Exported meshes
(`.stl`, `.3mf`, …) are treated as build artifacts and are **not** committed —
they are regenerated from the `.scad` sources.

## Repository layout

```
manifold/
├── models/            # one folder per model
│   └── <model-name>/
│       ├── <model-name>.scad   # the model source
│       └── README.md           # what it is, params, print settings
├── lib/               # shared, reusable .scad modules
├── CLAUDE.md          # conventions & guidance for AI agents
├── .gitignore
└── README.md
```

## Working with a model

Render or export a model with the OpenSCAD CLI:

```sh
# Preview / open in the GUI
openscad models/phone-stand/phone-stand.scad

# Export a printable mesh (output is gitignored)
openscad -o phone-stand.stl models/phone-stand/phone-stand.scad
```

## Adding a new model

1. Create `models/<model-name>/`.
2. Add `<model-name>.scad` with tunable parameters at the top of the file.
3. Add a `README.md` for the model describing the part, its parameters, and
   recommended print settings (layer height, infill, supports, orientation).
4. Commit the `.scad` source and docs — the exported mesh stays local.

## License

_TBD._
