// joint.scad — the print-in-place ball joint of the spider (renders nothing).
//
// Two pieces meet at a joint:
//
//   hood   the round bulb of the inner piece (body or leg segment), with a
//          spherical SOCKET inside it and an opening on one side.
//   ball   the root of the outer segment, printed inside the socket. A neck
//          leads from it out through the opening to the segment's own bulb.
//
// The ball turns in its socket in every direction: it swings side to side,
// nods up and down, and twists about the neck. The opening's edges are the
// stops.
//
// Nothing is printed onto an air gap, and nothing overhangs past 45 deg:
//   - the ball stands on the bed, cut off where its surface reaches 45 deg;
//   - the socket is a sphere `gap` bigger than the ball, so it wraps under
//     the ball's sides and holds it once it is off the bed. Its top closes in
//     a 45 deg cone rather than a flat ceiling;
//   - the neck is a bar standing on the bed;
//   - the opening's roof is a 45 deg cone too, high enough for the neck to
//     nod up by `nod_up`.
//
// Coordinates: the socket's centre is over the origin, bed = z 0, the outer
// segment leaves along +x.

$fn = 40;

// --- fit ---
gap        = 0.4;   // clearance all round the ball (0.54 at the bed)

// --- ball and neck ---
ball_r     = 3.15;  // ball radius
ball_z     = 0.72 * ball_r;  // ball centre height: the bed cuts the ball just
                    //   below its 45 deg line, so its underside self-supports
neck_w     = 2.0;   // neck width
neck_h     = ball_z + 0.95;  // neck height, from the bed
nod_up     = 15;    // how far a segment nods up, deg

// --- hood (the visible bulb) ---
bulb_r      = 4.75; // bulb radius
bulb_h      = 8.6;  // bulb height at the top of its dome
bulb_wall_h = 4.5;  // height of the bulb's straight side before the dome
pitch       = 2 * bulb_r + 1;  // joint to joint; leaves 1 mm between bulbs

socket_r   = ball_r + gap;
BIG        = 40;

module ball()
    intersection() {
        translate([0, 0, ball_z]) sphere(ball_r);
        translate([-ball_r, -ball_r, 0]) cube(2 * ball_r);
    }

// The neck from inside the ball out to the segment's bulb at x = length,
// ending 0.5 mm inside that bulb's wall (clear of its socket).
module neck(length)
    translate([ball_r / 2, -neck_w / 2, 0])
        cube([length - ball_r / 2 - (socket_r + 0.5), neck_w, neck_h]);

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

// The socket: a sphere, closed on top by a 45 deg cone tangent to it (the
// hull with a point at socket_r * sqrt(2) above the centre), and carried
// just through the bed so it opens onto the bed cleanly. One hull, so no
// seam is left between the pieces.
module socket()
    translate([0, 0, ball_z]) hull() {
        sphere(socket_r);
        translate([0, 0, socket_r * sqrt(2) - 0.01]) cylinder(r = 0.01, h = 0.01);
        translate([0, 0, -ball_z - 0.5])
            cylinder(r = sqrt(socket_r * socket_r - ball_z * ball_z),
                     h = 0.5);
    }

// What a hood removes from whatever it is built into: the socket, and the
// opening the neck swings through (+-swing degrees about +x). The opening is
// the sector under a 45 deg cone that, at the socket's wall, is high enough
// for the neck to nod up by nod_up.
module socket_cut(swing, reach = bulb_r + 3) {
    side = swing + asin((neck_w / 2 + gap) / socket_r);
    roof = neck_h + gap + socket_r * tan(nod_up);  // roof height at socket_r
    socket();
    difference() {
        linear_extrude(BIG, center = true)
            polygon([[0, 0],
                     for (a = [-side : side / 4 : side])
                         reach / cos(side) * [cos(a), sin(a)]]);
        // the material over the roof: a cone widening upward at 45 deg
        translate([0, 0, roof - socket_r]) cylinder(r1 = 0, r2 = BIG, h = BIG);
    }
}

// A free-standing hood: the bulb with its socket cut in.
module hood(swing)
    difference() {
        bulb();
        socket_cut(swing);
    }
