// cloud — the snow cloud that closes the chimney's top.
//
// A heap of round puffs wider than the chimney. Underneath, a solid plug
// fills the top section's pocket (which has no gate), including the front
// notch, and sits on its rim's 45° bevel like a section would; a skirt hangs
// round the front and sides of the section's top. The shaft is closed. The
// back is cut flat on the chimney's back plane, to sit against the wall.
//
// Prints on its flat underside, plug and skirt on the bed. Every puff hangs on a 45° cone under its
// equator (an upside-down teardrop) that ends inside the puffs below it or
// under the bed, so nothing needs support.
//
// COLOUR. `accent = false` (the default) writes the cloud as one solid, for
// the checks and a one-colour print. `accent = true` writes it as two
// top-level objects that together are exactly that solid: the cloud, and
// snowflakes inlaid flush in its front, `flake_d` deep. The flakes share
// layers with the cloud, so every layer they span costs a filament swap;
// keep them low and in one row to keep that short. Export with
// --enable=lazy-union and convert with tools/multicolor-3mf.py (see README).

include <../../lib/chimney.scad>

/* [Cloud] */
// [x, y, z, r]: x across from the chimney's middle, y back from its middle,
// z of the puff's centre above the underside
puffs = [
    // front row
    [-59, -21,  13,  21], [-28, -24,  17,  27], [  6, -25,  18,  28],
    [ 38, -22,  15,  25], [ 64, -13,  11,  17],
    // back row
    [-56,  20,  14,  22], [-18,  22,  21,  28], [ 21,  22,  20,  28], [ 57,  17,  13,  20],
    // crown
    [-25,  -1,  38,  24], [ 13,   0,  43,  27], [ 42,   3,  32,  18],
];
core_o = 3;          // the core under the puffs reaches this far past the chimney
                     //   (the skirt round the section's top is this, less skirt_gap)
core_h = 20;         // core height
skirt_gap = 0.2;     // skirt to the section's outside, per side (it only hides
                     //   the joint; the plug is what grips)

/* [Snowflakes] */
// [x, z, size, turn]: centre across from the chimney's middle and above the
// underside, tip-to-tip size, rotation in degrees. Each sits on the front of
// a puff, near the puff's centre height where it faces forward.
flakes = [
    [-59,  14,  15,  20], [-28,  18,  22,   0], [  6,  20,  24,  15], [ 38,  17,  21,  30],
];
flake_w = 1.4;      // arm width (two lines on a 0.4 nozzle)
flake_d = 1.2;      // inlay depth, front to back

/* [Colour] */
accent       = false;
base_color   = "white";         // preview tint only; the slicer picks filaments
accent_color = "deepskyblue";

$fn = 48;

// A puff: a ball over a 45° cone, so its underside prints without support.
module puff(p)
    translate([p[0], p[1], p[2]]) hull() {
        sphere(p[3]);
        translate([0, 0, -p[3] * sqrt(2)]) sphere(0.01);
    }

plug_h = pocket_d - gate_vgap;   // plug and skirt reach this far below the joint

// What fills the top section's pocket: the ring a section would hang there,
// the space below it where a gate would lie, and the front notch.
module plug() {
    ring_solid();
    slab(-plug_h, plug_h) ch_rect(-(rim + joint_gap));
    translate([-(in_w / 2 + groove_d - joint_gap), -joint_gap - 0.01, -plug_h])
        cube([in_w + 2 * (groove_d - joint_gap), rim + 1, plug_h]);
}

// In the joint frame: z = 0 is the top section's top edge.
module cloud() {
    difference() {
        intersection() {
            translate([0, ch_d / 2, 0]) union() {
                for (p = puffs) puff(p);
                // fill between the puffs' centres, or gaps among them are
                // left as sealed pockets inside the cloud
                hull() for (p = puffs) translate([p[0], p[1], p[2]]) cube(0.01, center = true);
                // a flat core so the underside covers the whole pocket and
                // wraps the section's top as a skirt
                translate([0, 0, -plug_h]) linear_extrude(core_h + plug_h) offset(r = core_o)
                    square([ch_w, ch_d], center = true);
            }
            // nothing below the underside or behind the chimney's back
            translate([-500, ch_d - 1000, -plug_h]) cube(1000);
        }
        // room for the top section, less the plug that goes into it
        difference() {
            slab(-plug_h - 1, plug_h + 1) ch_rect(skirt_gap);
            plug();
        }
        // ... with a 45° roof over the gap round the section's top edge
        difference() {
            hull() {
                slab(-0.001, 0.001) ch_rect(skirt_gap);
                slab(skirt_gap, 0.001) ch_rect(0);
            }
            slab(-1, 2) ch_rect(0);
        }
    }
}

// A six-armed snowflake, `size` tip to tip, centred on the origin.
module snowflake(size) {
    r = size / 2;
    w = flake_w;
    circle(d = w * 2.4, $fn = 6);
    for (a = [0:60:300]) rotate(a) {
        translate([0, -w / 2]) square([r, w]);
        // a pair of branches part way out
        for (s = [-1, 1]) translate([r * 0.55, 0]) rotate(s * 50)
            translate([0, -w / 2]) square([r * 0.38, w]);
    }
}

// The front skin under each snowflake: what the flake's outline, pushed in
// from the front, meets within `flake_d` of the surface.
module flake_region() {
    difference() {
        intersection() {
            cloud();
            // union() matters: under --enable=lazy-union a bare for() here
            // would be intersected flake by flake, leaving nothing
            union() for (f = flakes) translate([f[0], 200, f[1]]) rotate([90, 0, 0])
                linear_extrude(400) rotate(f[3]) snowflake(f[2]);
        }
        translate([0, flake_d, 0]) cloud();
    }
}

if (accent) {
    color(base_color)   difference()   { cloud(); flake_region(); }
    color(accent_color) flake_region();
} else
    cloud();
