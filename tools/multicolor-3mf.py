#!/usr/bin/env python3
"""Turn an OpenSCAD lazy-union 3MF into ONE multicolour object.

    openscad --enable=lazy-union -o in.3mf model.scad
    python3 tools/multicolor-3mf.py in.3mf out.3mf

OpenSCAD writes every top-level `color()`ed solid as its own <object>, so a
slicer loads them as separate models, all in one filament. This rewrites the
file as a single object whose PARTS are those solids, and assigns each distinct
colour its own filament (1, 2, ... in order of first appearance). The filament
assignment lives in `Metadata/model_settings.config`, the Bambu Studio /
OrcaSlicer / Creality Print project format; other slicers still read the
parts as one object from the standard 3MF core.

Geometry is copied verbatim: vertices, triangles and positions are untouched.
"""
import sys
import zipfile
import xml.etree.ElementTree as ET

CORE = "http://schemas.microsoft.com/3dmanufacturing/core/2015/02"
MAT = "http://schemas.microsoft.com/3dmanufacturing/material/2015/02"
NS = {"c": CORE, "m": MAT}


def read_parts(path):
    """[(name, colour, vertices-xml, triangles-xml)] for every mesh object."""
    root = ET.fromstring(zipfile.ZipFile(path).read("3D/3dmodel.model"))
    bases = {}
    # OpenSCAD writes <basematerials> in the core namespace, the spec in the
    # materials one; accept both.
    for group in [*root.iterfind(".//c:basematerials", NS),
                  *root.iterfind(".//m:basematerials", NS)]:
        for i, base in enumerate([*group.iterfind("c:base", NS),
                                  *group.iterfind("m:base", NS)]):
            bases[(group.get("id"), str(i))] = base.get("displaycolor", "#FFFFFFFF")
    parts = []
    for obj in root.iterfind("c:resources/c:object", NS):
        mesh = obj.find("c:mesh", NS)
        if mesh is None:
            continue
        tris = mesh.find("c:triangles", NS)
        # A triangle's own material wins over the object's default one.
        first = tris.find("c:triangle", NS)
        pid = first.get("pid", obj.get("pid"))
        pindex = first.get("p1", obj.get("pindex", "0"))
        colour = bases.get((pid, pindex), "#FFFFFFFF")
        parts.append((obj.get("name") or f"part {len(parts) + 1}",
                      colour, mesh.find("c:vertices", NS), tris))
    return parts


def write(path, name, parts):
    colours = []
    for _, colour, _, _ in parts:
        if colour not in colours:
            colours.append(colour)

    out = [f'<?xml version="1.0" encoding="UTF-8"?>',
           f'<model unit="millimeter" xml:lang="en-US" xmlns="{CORE}" xmlns:m="{MAT}">',
           f' <metadata name="Title">{name}</metadata>',
           f' <metadata name="Application">OpenSCAD + tools/multicolor-3mf.py</metadata>',
           ' <resources>',
           '  <m:basematerials id="1">']
    out += [f'   <m:base name="filament {i + 1}" displaycolor="{c}"/>'
            for i, c in enumerate(colours)]
    out.append('  </m:basematerials>')
    for i, (_, colour, verts, tris) in enumerate(parts):
        out.append(f'  <object id="{i + 2}" type="model" pid="1" '
                   f'pindex="{colours.index(colour)}"><mesh><vertices>')
        out += [f'<vertex x="{v.get("x")}" y="{v.get("y")}" z="{v.get("z")}"/>'
                for v in verts]
        out.append('</vertices><triangles>')
        out += [f'<triangle v1="{t.get("v1")}" v2="{t.get("v2")}" v3="{t.get("v3")}"/>'
                for t in tris]
        out.append('</triangles></mesh></object>')
    top = len(parts) + 2
    out.append(f'  <object id="{top}" name="{name}" type="model"><components>')
    out += [f'   <component objectid="{i + 2}"/>' for i in range(len(parts))]
    out += ['  </components></object>', ' </resources>',
            f' <build><item objectid="{top}"/></build>', '</model>']

    cfg = ['<?xml version="1.0" encoding="UTF-8"?>', '<config>',
           f' <object id="{top}">',
           f'  <metadata key="name" value="{name}"/>',
           '  <metadata key="extruder" value="1"/>']
    for i, (pname, colour, _, _) in enumerate(parts):
        cfg += [f'  <part id="{i + 2}" subtype="normal_part">',
                f'   <metadata key="name" value="{pname} ({colour[:7]})"/>',
                f'   <metadata key="extruder" value="{colours.index(colour) + 1}"/>',
                '  </part>']
    cfg += [' </object>', '</config>']

    types = ('<?xml version="1.0" encoding="UTF-8"?>\n'
             '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
             '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
             '<Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>'
             '<Default Extension="config" ContentType="text/xml"/>'
             '</Types>')
    rels = ('<?xml version="1.0" encoding="UTF-8"?>\n'
            '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Target="/3D/3dmodel.model" Id="rel0" '
            'Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>'
            '</Relationships>')
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("[Content_Types].xml", types)
        z.writestr("_rels/.rels", rels)
        z.writestr("3D/3dmodel.model", "\n".join(out))
        z.writestr("Metadata/model_settings.config", "\n".join(cfg))
    return colours


if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    src, dst = sys.argv[1], sys.argv[2]
    parts = read_parts(src)
    if len(parts) < 2:
        sys.exit(f"{src}: {len(parts)} object(s) — export with --enable=lazy-union")
    name = dst.rsplit("/", 1)[-1].removesuffix(".3mf")
    colours = write(dst, name, parts)
    for i, (pname, colour, _, tris) in enumerate(parts):
        print(f"part {i + 1}: {len(tris)} triangles, {colour[:7]} -> filament "
              f"{colours.index(colour) + 1}")
