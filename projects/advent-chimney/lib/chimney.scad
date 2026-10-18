// advent-chimney — shared dimensions and geometry. Renders nothing on its own.
//
// One frame for every model, the USE frame of a single section: x across the
// chimney's front, y from the front face (y = 0) back, z up from the
// section's bottom (z = 0). The chimney's footprint is centred on x = 0.
//
// Every joint in the stack is the same. The piece below has a POCKET in its
// top: its wall cut back to a thin outer rim, open upward, the rim's top
// bevelled 45° inward. The gate plate lies on the pocket's floor and slides
// out through a notch in the front wall, also open upward, so nothing about
// the gate is ever printed over air. The piece above has a RING under it:
// the inner part of its wall hanging down into the pocket over the plate,
// its outside bevelled 45° to sit on the rim's bevel. The ring lines the
// pieces up. The fireplace's top is a pocket (day 1), every section has a
// ring under and a pocket on top, and the cloud has a plug that fills the
// top section's empty pocket.

$fn = 64;

// ---- Chimney section -----------------------------------------------------
ch_w  = 100;     // outside width, across the front
ch_d  = 70;      // outside depth, front to back
ch_h  = 40;      // height of one section (the stack's pitch)
wall  = 3.6;     // wall thickness at the brick faces

in_w = ch_w - 2 * wall;     // shaft inside, 92.8
in_d = ch_d - 2 * wall;     // 62.8

// ---- Bricks (mortar is a recessed groove) --------------------------------
course   = 10;   // brick course height, mortar included; ch_h is 4 courses
pitch    = 30;   // brick length, mortar included
mortar   = 1.0;  // mortar line width
mortar_d = 0.6;  // how deep the mortar is set back from the brick face
min_brick = 5;   // shortest brick end left at a corner

assert(abs(ch_h / course - round(ch_h / course)) < 1e-6
       && round(ch_h / course) % 2 == 0,
       "a section must be an even number of courses, or the bond breaks between sections");

// ---- Stacking joint and gate --------------------------------------------
groove_d  = 1.8;  // how far the pocket reaches into the walls
rim       = wall - groove_d;  // the pocket's outer rim (1.2 behind the mortar)
ring_v    = 3.0;  // straight part of the ring under a piece, below its bevel;
                  //   the length that grips the pocket wall
joint_gap = 0.05; // ring to pocket wall, per side (tight: pushing a section
                  //   in takes effort; 0.15 printed loose)

gate_t    = 2.0;  // plate thickness
gate_side = 0.6;  // plate edge to pocket wall, per side (loose, it slides;
                  //   0.3 printed tight)
gate_vgap = 0.5;  // plate to the ring above it (0.2 printed tight)

// pocket depth below the joint: bevel, the ring's straight part, the plate
pocket_d = rim + ring_v + gate_vgap + gate_t;
gate_z   = ch_h - pocket_d;   // plate underside, in the section below's frame

assert(rim >= mortar_d + 1.2, "pocket rim too thin behind the mortar");
assert(wall - rim - joint_gap >= 1.2, "ring under a section too thin");

// ---- Helpers -------------------------------------------------------------

// Rectangle of the chimney's footprint, grown by `o` (negative shrinks).
module ch_rect(o = 0)
    translate([-ch_w / 2 - o, -o]) square([ch_w + 2 * o, ch_d + 2 * o]);

// A flat slice of a 2D shape, z in [z0, z0 + h].
module slab(z0, h) translate([0, 0, z0]) linear_extrude(h) children();

// ---- Brick texture -------------------------------------------------------

// Head-joint positions along a face `len` long, centred on 0, for a course
// of parity `p`. Odd and even courses are shifted half a brick, and corners
// alternate long and short ends.
function head_joints(len, p) =
    [for (i = [-20:20]) let(x = (p == 0 ? pitch / 2 : 0) + i * pitch)
        if (abs(x) < len / 2 - min_brick) x];

// The mortar to cut out of a w x d box (front face at y = y0, centred on
// x = 0), courses from z0 to z1 with bed joints on every multiple of
// `course`. Bed joints have a 45° roof so they print without support.
// `course0` is the global index of the course starting at z0, so the bond
// carries on across pieces. `top_open`: z1 is the piece's top face (a
// section's), and its joint is a plain step; otherwise something wider sits
// on z1 (the fireplace's corbel) and the bricks just end there.
// `bottom_cut`: how far the bottom joint's cut reaches below z0, to clear
// the bevelled ring hanging under a section instead of leaving a sliver.
module mortar_cut(w, d, z0, z1, y0 = 0, course0 = 0, top_open = true,
                  bottom_cut = 0) {
    n = round((z1 - z0) / course);
    // bed joints
    for (k = [0:top_open ? n : n - 1]) {
        zk = z0 + k * course;
        lo = k == 0 ? bottom_cut : 0;
        difference() {
            translate([-w / 2 - 1, y0 - 1, zk - mortar / 2 - lo])
                cube([w + 2, d + 2, mortar + lo]);
            // the top joint has nothing above it: a plain step, no feather
            if (k == n && top_open)
                translate([-w / 2 + mortar_d, y0 + mortar_d, zk - mortar / 2 - 0.01])
                    cube([w - 2 * mortar_d, d - 2 * mortar_d, mortar + 0.02]);
            else hull() {
                translate([-w / 2 + mortar_d, y0 + mortar_d, zk - mortar / 2 - lo - 0.01])
                    cube([w - 2 * mortar_d, d - 2 * mortar_d,
                          mortar - mortar_d + lo + 0.01]);
                translate([-w / 2, y0, zk + mortar / 2 - 0.001])
                    cube([w, d, 0.002]);
            }
        }
    }
    // head joints, one course at a time
    for (k = [0:n - 1]) {
        zk = z0 + k * course;
        p = (course0 + k) % 2;
        for (x = head_joints(w, p)) {
            translate([x, y0, zk]) head_cut();                          // front
            translate([x, y0 + d, zk]) mirror([0, 1, 0]) head_cut();    // back
        }
        for (yy = head_joints(d, p)) {
            translate([-w / 2, y0 + d / 2 + yy, zk]) rotate([0, 0, -90]) head_cut();
            translate([ w / 2, y0 + d / 2 + yy, zk]) rotate([0, 0,  90]) head_cut();
        }
    }
}

// One head joint on a face whose outside is -y, for the course starting at
// z = 0. It runs from inside the bed joint below to the bed joint above and
// its top follows that joint's 45° roof, so the two leave no sliver between.
module head_cut()
    hull() {
        translate([-mortar / 2, -1, -mortar / 2]) cube([mortar, 1, course + mortar]);
        translate([-mortar / 2, -1, -mortar / 2])
            cube([mortar, 1 + mortar_d, course + mortar - mortar_d]);
    }

// ---- Joint ---------------------------------------------------------------
// Both modules work in the JOINT frame: z = 0 is the joint line, the top of
// the piece below and the bottom edge of the piece above.

// What to cut from the top of the piece below: the rim's 45° bevel and the
// pocket. With `gate` the pocket is deep enough for the plate and has the
// front notch it slides out through.
module pocket_cut(gate = true) {
    d = gate ? pocket_d : rim + ring_v + gate_vgap;
    hull() {
        slab(-rim, 0.001) ch_rect(-rim);
        slab(1, 0.001) ch_rect(1);      // the 45° line through the outer edge
    }
    slab(-d, d + 1) ch_rect(-rim);
    if (gate)
        translate([-(in_w / 2 + groove_d), -1, -d])
            cube([in_w + 2 * groove_d, rim + 2, d + 2]);
}

// The ring under the piece above, solid (the caller cuts its shaft): a
// straight part inside the pocket, then the 45° bevel out to the outer edge
// that sits on the rim's bevel.
// (Not one hull: the bevel widens upward, so a hull would run straight from
// the straight part's bottom edge to the top and bulge past the bevel.)
module ring_solid() {
    slab(-(rim + ring_v), ring_v - joint_gap + 0.001) ch_rect(-(rim + joint_gap));
    hull() {
        slab(-(rim + joint_gap), 0.001) ch_rect(-(rim + joint_gap));
        slab(-0.001, 0.001) ch_rect(0);
    }
}
