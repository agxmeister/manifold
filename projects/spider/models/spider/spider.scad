// spider.scad — an articulated, print-in-place spider.
//
// One print, no assembly: a body with eight leg sockets, and eight legs of
// round segments. Each joint is the hood/knuckle pair from joint.scad, so
// every leg segment swings in the plane of the bed. Prints flat as exported,
// no supports.

include <joint.scad>

// --- legs ---
segments   = 5;     // leg segments per leg, the last one is the claw
leg_angles = [38, 72, 106, 142];  // leg directions, deg from straight ahead,
                                  //   mirrored for the left side
socket_at  = 24;    // distance of each body socket from the body centre
leg_swing  = 30;    // how far a segment swings either way, deg
coxa_swing = 20;    // the same at the body, where the legs sit closer
claw_len   = 10;    // how far the claw's point reaches past its last bulb

// --- body ---
head_rx    = 19;    // cephalothorax half-width
head_ry    = 24;    // cephalothorax half-length
head_h     = 15;    // cephalothorax height
head_y     = 0;     // cephalothorax centre
belly_rx   = 22;    // abdomen half-width
belly_ry   = 28;    // abdomen half-length
belly_h    = 25;    // abdomen height
belly_y    = -56;   // abdomen centre
dome_from  = 0.3;   // fraction of each body part's height taken by its
                    //   side (leaning in, never past 45 deg) before the dome

// --- face ---
eye_r      = 1.2;   // eye dimple radius
fang_len   = 7;     // fang reach in front of the head
fang_r     = 2.6;   // fang root radius
fang_x     = 4.5;   // fang offset either side of the centre line

// A dome on an elliptical footprint: straight sides that lean in by at most
// 45 deg near the bed, then a half-ellipsoid on top.
module body_dome(rx, ry, h) {
    wall_h = h * dome_from;
    inset  = min(wall_h, 0.15 * min(rx, ry));
    intersection() {
        hull() {
            scale([(rx - inset) / rx, (ry - inset) / ry, 1])
                linear_extrude(0.01) scale([rx, ry]) circle(1);
            translate([0, 0, wall_h])
                scale([rx, ry, h - wall_h]) sphere(1);
        }
        translate([-rx, -ry, 0]) cube([2 * rx, 2 * ry, h]);
    }
}

// Socket i: position and outward direction. Right side for i < 4, left side
// mirrored.
function leg_dir(i) = i < len(leg_angles) ? leg_angles[i]
                                          : -leg_angles[i - len(leg_angles)];
// Compass angle (deg from +y, clockwise) -> OpenSCAD rotation about z
// that turns +x onto it.
function rot(a) = 90 - a;
function socket_pos(i) = socket_at * [sin(leg_dir(i)), cos(leg_dir(i)), 0];

module at_socket(i)
    translate(socket_pos(i)) rotate([0, 0, rot(leg_dir(i))]) children();

module body()
    difference() {
        union() {
            translate([0, head_y, 0])  body_dome(head_rx, head_ry, head_h);
            translate([0, belly_y, 0]) body_dome(belly_rx, belly_ry, belly_h);
            // the pedicel between them
            hull() {
                translate([0, head_y - head_ry + 4, 0]) cylinder(r = 7, h = 7);
                translate([0, belly_y + belly_ry - 4, 0]) cylinder(r = 7, h = 7);
            }
            for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) bulb();
            fangs();
        }
        for (i = [0 : 2 * len(leg_angles) - 1])
            at_socket(i) socket_cut(coxa_swing);
        eyes();
    }

// Two fangs lying on the bed at the front, pointed tips forward and down.
module fangs()
    for (s = [-1, 1])
        hull() {
            translate([s * fang_x, head_y + head_ry - 4, 0])
                cylinder(r = fang_r, h = 5);
            translate([s * (fang_x + 0.5), head_y + head_ry + fang_len, 0])
                cylinder(r = 0.6, h = 1.2);
        }

// Eight small eyes, dimpled into the front of the head.
module eyes() {
    // [x, fraction of head_ry ahead of the head's centre], spaced so the
    // ridges between dimples stay > 1.2 mm
    pts = [[-2.2, 0.84], [2.2, 0.84], [-6.4, 0.84], [6.4, 0.84],
           [-3.6, 0.7], [3.6, 0.7], [-7.8, 0.62], [7.8, 0.62]];
    for (p = pts) {
        // a point on the dome at x = p.x, y = p.y * head_ry
        x = p[0]; y = p[1] * head_ry;
        u = 1 - pow(x / head_rx, 2) - pow(y / head_ry, 2);
        z = head_h * dome_from + (head_h * (1 - dome_from)) * sqrt(max(u, 0));
        translate([x, head_y + y, z]) sphere(eye_r, $fn = 16);
    }
}

// The claw: the last segment's bulb drawn out into a point on the bed.
module claw()
    hull() {
        bulb(h = bulb_h - 1);
        translate([bulb_r + claw_len - 1, 0, 0]) cylinder(r = 0.8, h = 2);
    }

// One leg segment, its knuckle at the origin and its bulb at x = pitch.
module segment(last) {
    knuckle();
    neck(pitch);
    translate([pitch, 0, 0])
        if (last) claw(); else hood(leg_swing);
}

module leg()
    for (k = [0 : segments - 1])
        translate([k * pitch, 0, 0]) segment(k == segments - 1);

module spider() {
    body();
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) leg();
}

spider();
