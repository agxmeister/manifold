// spider.scad — an articulated, print-in-place spider.
//
// One print, no assembly: a body with eight leg sockets, and eight legs of
// links. Each joint is the hidden ring joint from joint.scad: a tab with a
// window on one link, threaded by a crossbar inside the hood of the next,
// ring through ring like a chain, so every link swings, nods and twists. The
// body's sockets are hoods too, built into the coxae round the head, so the
// first rings are hidden in the body. Prints flat as exported, no supports.

include <joint.scad>

// --- legs ---
segments   = 4;     // leg segments per leg, the last one is the claw
leg_angles = [38, 72, 106, 142];  // leg directions, deg from straight ahead,
                                  //   mirrored for the left side
socket_at  = 15;    // distance of each socket's crossbar from the body
                    //   centre; the coxae there merge into a ring round the head
stub_from  = [8, 3, 3, 3];  // where each coxa starts, from the body centre,
                    //   buried in the head
coxa_h     = 7;     // the coxae's height, below the head's flanks, so each
                    //   coxa comes out of the head's side without a step
coxa_wall_h = 5.5;  // the coxae's straight sides; high, to roof the cavity
pitch      = 16;    // joint to joint along a leg
claw_len   = 8;     // how far the claw's point reaches past its shoulder

// --- body ---
head_rx    = 12;    // cephalothorax half-width
head_ry    = 13;    // cephalothorax half-length
head_h     = 10;    // cephalothorax height; its flanks are higher than
                    //   the coxae where they come out of it
head_y     = 0;     // cephalothorax centre
belly_rx   = 11;    // abdomen half-width
belly_ry   = 14;    // abdomen half-length
belly_h    = 13;    // abdomen height
belly_y    = -30;   // abdomen centre
dome_from  = 0.3;   // fraction of each body part's height taken by its
                    //   side (leaning in, never past 45 deg) before the dome

// --- face ---
eye_r      = 0.5;    // eye dimple radius
fang_len   = 3.5;     // fang reach in front of the head
fang_r     = 1.4;   // fang root radius
fang_x     = 2.3;   // fang offset either side of the centre line

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

module body() {
    difference() {
        union() {
            translate([0, head_y, 0])  body_dome(head_rx, head_ry, head_h);
            translate([0, belly_y, 0]) body_dome(belly_rx, belly_ry, belly_h);
            // the pedicel between them
            hull() {
                translate([0, head_y - head_ry + 2, 0]) cylinder(r = 3.5, h = 4);
                translate([0, belly_y + belly_ry - 2, 0]) cylinder(r = 3.5, h = 4);
            }
            // the coxae: a hood for each leg
            for (i = [0 : 2 * len(leg_angles) - 1])
                at_socket(i) hood_solid(stub_from[i % len(leg_angles)] - socket_at, coxa_h, coxa_wall_h);
            fangs();
        }
        for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) cavity();
        eyes();
    }
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) crossbar();
}

// Two fangs lying on the bed at the front, pointed tips forward and down.
module fangs()
    for (s = [-1, 1])
        hull() {
            translate([s * fang_x, head_y + head_ry - 2, 0])
                cylinder(r = fang_r, h = 3);
            translate([s * (fang_x + 0.3), head_y + head_ry + fang_len, 0])
                cylinder(r = 0.5, h = 1);
        }

// Eight small eyes, dimpled into the front of the head.
module eyes() {
    // [x, fraction of head_ry ahead of the head's centre]
    pts = [[-0.92, 0.84], [0.92, 0.84], [-2.75, 0.84], [2.75, 0.84],
           [-1.8, 0.7], [1.8, 0.7], [-3.9, 0.62], [3.9, 0.62]];
    for (p = pts) {
        // a point on the dome at x = p.x, y = p.y * head_ry
        x = p[0]; y = p[1] * head_ry;
        u = 1 - pow(x / head_rx, 2) - pow(y / head_ry, 2);
        z = head_h * dome_from + (head_h * (1 - dome_from)) * sqrt(max(u, 0));
        translate([x, head_y + y, z]) sphere(eye_r, $fn = 16);
    }
}

// The claw: the last link drawn out into a point on the bed.
module claw() {
    link_start(body_x + 3);
    hull() {
        link_body(body_x, body_x + 3);
        translate([body_x + claw_len - 0.5, 0, 0]) cylinder(r = 0.5, h = 1.2);
    }
}

// One leg link: its tab round the origin, its own hood at x = pitch.
module segment(last) {
    if (last) claw();
    else {
        difference() {
            union() {
                link_start(pitch);
                translate([pitch, 0, 0]) knuckle();
            }
            translate([pitch, 0, 0]) cavity();
        }
        translate([pitch, 0, 0]) crossbar();
    }
}

assert(body_x < pitch + cavity_rear - 1, "the link is too short for its hood's cavity");

module leg()
    for (k = [0 : segments - 1])
        translate([k * pitch, 0, 0]) segment(k == segments - 1);

module spider() {
    body();
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) leg();
}

spider();
