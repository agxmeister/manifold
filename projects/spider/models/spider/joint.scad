// joint.scad — the print-in-place leg joint of the spider (renders nothing).
//
// Every joint turns about a VERTICAL axis, so the legs swing in the plane of
// the bed. Two pieces meet at a joint:
//
//   hood     the round bulb of the inner piece (body or leg segment). Inside
//            it, an hourglass PIN stands on the bed and flares at the top
//            into the hood's roof.
//   knuckle  the ring at the root of the outer segment, printed around the
//            pin's waist. A neck leads from it out through a slot in the
//            hood to the segment's own bulb.
//
// Everything is a body of revolution about the joint axis, so no surface is
// flatter than `slope` and nothing is printed onto an air gap:
//   - the pin stands on the bed; its upper cone grows out of it at `slope`
//     and becomes the hood's roof, so the roof never bridges;
//   - the knuckle stands on the bed; its hole narrows upward over the pin's
//     lower cone, again at `slope`;
//   - the hourglass holds the knuckle both ways: it can't lift off the pin
//     or drop off it.
//
// Coordinates: joint axis = z axis, bed = z 0, the outer segment leaves
// along +x.

$fn = 48;

// --- fit ---
gap        = 0.4;   // normal clearance, pin to knuckle and knuckle to hood
foot_cut   = 0.4;   // chamfer on the knuckle's outer bed edge; with it the
                    //   first layers of knuckle and hood stay >= 0.5 apart

// --- pin (hourglass) ---
pin_waist_r = 1.6;  // pin radius at its narrowest
pin_waist_z = 1.4;  // height of the waist above the bed
pin_waist_h = 1.6;  // the waist runs straight this far before flaring, so
                    //   the knuckle keeps some height at its inner edge
slope       = 0.85; // cone flare, horizontal mm per vertical mm (~40 deg
                    //   from vertical)

// --- knuckle and neck ---
knuckle_r  = 5.4;   // knuckle outer radius
neck_w     = 4;     // neck width

// --- hood (the visible bulb) ---
bulb_r      = 7.4;  // bulb radius
bulb_h      = 12.5;  // bulb height at the top of its dome
bulb_wall_h = 6.2;  // height of the bulb's straight side before the dome
pitch       = 2 * bulb_r + 1;  // joint to joint; leaves 1 mm between bulbs

BIG = 40;           // "tall enough" for open-topped 2D profiles

// Horizontal gap on a sloped face carrying normal clearance `gap`.
slope_gap = gap * sqrt(1 + slope * slope);

// Height of the knuckle (and neck) at the knuckle's outer edge: where the
// pin's upper cone, plus clearance, reaches knuckle_r.
neck_h = pin_waist_z + pin_waist_h + (knuckle_r - pin_waist_r - slope_gap) / slope;

// Pin profile in the (r, z) half-plane.
module pin_2d()
    polygon([[0, -1],
             [pin_waist_r + slope * (pin_waist_z + 1), -1],
             [pin_waist_r, pin_waist_z],
             [pin_waist_r, pin_waist_z + pin_waist_h],
             [pin_waist_r + slope * (BIG - pin_waist_z - pin_waist_h), BIG],
             [0, BIG]]);

// Knuckle profile out to radius r_max: a ring around the pin, its top
// limited by the pin's upper cone (so it closes off by itself at neck_h
// when r_max = knuckle_r).
module knuckle_2d(r_max)
    difference() {
        polygon([[0, 0], [r_max - foot_cut, 0], [r_max, foot_cut],
                 [r_max, BIG], [0, BIG]]);
        offset(r = gap) pin_2d();
    }

// Grow a profile by the clearance, kept on the r >= 0 side. Sharp corners
// (delta, not r): a rounded corner above the knuckle's rim would leave a
// flat ring in the hood's ceiling.
module clearance_2d()
    intersection() {
        offset(delta = gap) children();
        translate([0, -5]) square([BIG * 2, BIG * 2]);
    }

module knuckle() rotate_extrude() knuckle_2d(knuckle_r);

// The neck from the knuckle out to the segment's bulb at x = length. It is
// as tall as the knuckle's rim and ends 0.7 mm inside the bulb's wall.
module neck(length)
    intersection() {
        translate([knuckle_r - 1.5, -neck_w / 2, 0])
            cube([length - (knuckle_r - 1.5) - (knuckle_r + gap + 0.7),
                  neck_w, neck_h]);
        rotate_extrude() knuckle_2d(length);
    }

// The bulb, solid: a straight side, then a dome.
module bulb(r = bulb_r, h = bulb_h, wall_h = bulb_wall_h)
    intersection() {
        hull() {
            cylinder(r = r, h = wall_h);
            translate([0, 0, wall_h])
                scale([1, 1, (h - wall_h) / r]) sphere(r);
        }
        translate([-r, -r, 0]) cube([2 * r, 2 * r, h]);
    }

// What a hood removes from whatever it is built into: the knuckle's room,
// and the slot the neck swings through (+-swing degrees about +x). The
// slot's ceiling is the pin's cone carried outward, so it never bridges.
module socket_cut(swing, reach = bulb_r + 6) {
    rotate_extrude() clearance_2d() knuckle_2d(knuckle_r);
    intersection() {
        rotate_extrude() clearance_2d() knuckle_2d(reach);
        for (a = [-swing : 5 : swing - 5])
            hull() for (b = [a, a + 5]) rotate([0, 0, b])
                translate([0, -(neck_w / 2 + gap), -1])
                    cube([reach, neck_w + 2 * gap, BIG]);
    }
}

// A free-standing hood: the bulb with its socket cut in.
module hood(swing)
    difference() {
        bulb();
        socket_cut(swing);
    }
