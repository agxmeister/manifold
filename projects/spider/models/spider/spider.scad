// spider.scad — an articulated, print-in-place spider.
//
// One print, no assembly: a body with eight leg sockets, eight legs of
// links, and an abdomen on a ninth joint at the waist, hidden inside it.
// Each joint is the hidden ring joint from joint.scad: a tab with a
// window on one link, threaded by a crossbar inside the hood of the next,
// ring through ring like a chain, so every link swings, nods and twists.
// Along a leg the links butt up to each other at 45 deg seams, and the first
// link sits in a niche in the head, cut to the same seam.
// Prints flat as exported, no supports.

include <joint.scad>

// --- legs ---
segments   = 4;     // leg segments per leg, the last one is the claw
leg_angles = [43, 73, 103, 133];  // leg directions, deg from straight ahead,
                                  //   evenly spaced, as close as the first
                                  //   links' rear corners allow; mirrored for
                                  //   the left side
socket_at  = 13.5;  // distance of each socket's crossbar from the body
                    //   centre; its hood is the head itself
niche_swing = 3;    // how far a first link swings in its niche, each way
                    //   (plus the slack of the gap), in its arched cutout
pitch      = 13.5;  // joint to joint along a leg; as short as it gets with
                    //   the previous seam leaving this link tall enough to roof its cavity
claw_len   = 8;     // how far the foot reaches past its shoulder
                    // the foot ends in a half ball, the link's own radius

// --- rough skin: random dents and bumps round every link ---
rough_n    = 120;   // per link
rough_r    = [1.5, 3];     // their radius, at random between: wide and
rough_d    = [0.15, 0.35]; //   shallow, so they run into each other
rough_a    = 80;    // dents reach this far round the link from its top, each
                    //   way (deg; 90 is its side), above where the underside
                    //   turns into an overhang
bump_a     = 50;    // bumps only this far, where they print without sagging

// --- body ---
head_r     = 23;    // the head's footprint, a disc on the bed: it reaches past
                    //   the top of each socket's seam, so the seam is a niche
                    //   in the head
head_wall  = 10;    // the head's straight side, up from the bed: taller
                    //   than the legs, so each leg's arch has head over it
head_h     = 16;    // the head's height at its centre; the legs are `link_h`
head_y     = 0;     // cephalothorax centre
waist_at   = head_r + 4;  // the waist's crossbar, behind the head's centre,
                    //   inside the abdomen: the abdomen is the hood, the
                    //   head's tab hangs in it, and the head's back is cut
                    //   to the seam the abdomen's front leans over
belly_rx   = 13;    // abdomen half-width
belly_ry   = 21;    // abdomen half-length
belly_h    = 18;    // abdomen height
belly_front = 12;   // the abdomen's front, ahead of the waist's crossbar:
                    //   past the seam, so the seam shapes its nose
sweep_step = 2.5;   // the abdomen is cut round the head swung through
                    //   `swing`; the angle step of that
dome_from  = 0.3;   // fraction of the abdomen's height taken by its
                    //   side (leaning in, never past 45 deg) before the dome

// --- face ---
eye_r      = 1.2;   // eye dimple radius
fang_r     = [2.6, 2.6];    // the fangs' radius at root and tip
fang_x     = [2.8, 2.9];    // their offset either side of the centre line
fang_root  = [head_r - 3, 6.5];   // root centre [ahead of the head's
                    //   centre, height], on the head's front
fang_tip   = head_r + 2.5;  // how far ahead of the head's centre the tip
                    //   reaches; it lies on the bed, so the fang leans down
                    //   the head's front at about 45 deg

// A dome on an elliptical footprint: straight sides that lean in by at most
// 45 deg near the bed, then a half-ellipsoid on top.
module body_dome(rx, ry, h, wall_h = undef, lean = 0.15) {
    wall_h = is_undef(wall_h) ? h * dome_from : wall_h;
    inset  = min(wall_h, lean * min(rx, ry));
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

// The head's top at a point (x, y) from its centre.
function head_z(x, y) = head_wall + (head_h - head_wall)
                        * sqrt(max(1 - (x * x + y * y) / (head_r * head_r), 0));

// The cephalothorax: a low round dome standing on the bed, a straight side
// then a half-ellipsoid, solid round the legs' sockets, so the first rings
// are inside it.
module head()
    translate([0, head_y, 0]) hull() {
        cylinder(r = head_r, h = head_wall, $fn = 96);
        translate([0, 0, head_wall]) scale([head_r, head_r, head_h - head_wall])
            intersection() { sphere(1, $fn = 96); cylinder(r = 1, h = 1, $fn = 96); }
    }

// The head and the fangs, with an arched cutout for each leg, as if a ball
// were taken out of the head where the leg leaves it, only past the leg's
// seam, so the head's back wall leans over the first link as a link's front
// does. Neighbouring balls run into each other, so nothing of the head comes
// down to the bed between the legs. Its back is cut to the seam at the
// waist, as a link's rear is.
module head_cut()
    difference() {
        union() { head(); fangs(); }
        for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) intersection() {
            seam_front(niche_swing, 2 * ball_r + 2);
            leg_ball();
        }
        at_waist() waist_seam(seam_r + gap, seam_c + seam_v);
    }

// The ball: centred on the leg's line where it crosses the head's rim, on
// the bed, big enough to take the first link, `gap` clear, as far as it is
// inside the head; swung through the niche.
ball_at = head_r - socket_at;   // from the socket's crossbar
ball_r  = 9;                    // the arch's radius at the rim: the
                                //   first link's top fits under it, the
                                //   head's rim (`head_wall`) stands over it
module leg_ball()
    hull() for (t = [-niche_swing, niche_swing]) rotate([0, 0, t])
        translate([ball_at, 0, 0]) sphere(ball_r, $fn = 96);

// The waist's seam: a leg's seam turned about the waist's crossbar, so it is
// the same all round and the abdomen swings freely: everything within
// max(r, c + z) of the crossbar's vertical axis, a cylinder round the mouth
// then a cone opening up at 45 deg. The head loses it (`gap` out); ahead of
// the crossbar, the abdomen keeps only it.
module waist_seam(r, c)
    rotate_extrude($fn = 96) polygon([[0, -1], [r, -1], [r, r - c], [c + BIG, BIG], [0, BIG]]);

module body() {
    difference() {
        head_cut();
        // the legs' sockets, in the solid head, like a link's, swept only a
        // little past the niche, which stops the first link; the full sweep
        // only within the leg's width, where its rear drops as it droops
        for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) {
            cavity(neck_roof, jaws = false, sw = 10);
            intersection() {
                cavity(neck_roof, jaws = false);
                translate([0, -link_w / 2, -1]) cube([BIG, link_w, BIG]);
            }
        }
        eyes();
    }
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) { crossbar(); droop_stop(); }
    // the waist: the head's tab and neck, out of its back into the abdomen
    at_waist() { tab(); neck(); }
}

// The waist: its crossbar on the centre line behind the head, inside the
// abdomen; +x points forward, at the head, the abdomen lies along -x.
module at_waist() translate([0, head_y - waist_at, 0]) rotate([0, 0, 90]) children();

// The abdomen, a separate piece: an egg holding the waist's hood, the
// cavity with its crossbar that the head's tab hangs on, so it swings, nods
// and twists like a leg's link on the one before. Ahead of the crossbar it
// is cut to the waist's seam, a round nose leaning over the head's back, so
// the joint is hidden under it; beside it, round the head swung through
// `swing`.
module abdomen()
    at_waist() {
        difference() {
            translate([belly_front - belly_ry, 0, 0]) body_dome(belly_ry, belly_rx, belly_h);
            difference() {
                for (t = [-swing : sweep_step : swing]) rotate([0, 0, t])
                    rotate([0, 0, -90]) translate([0, waist_at - head_y, 0]) minkowski() {
                        head(); sphere(gap, $fn = 8);
                    }
                waist_seam(seam_r, seam_c);
            }
            cavity(neck_roof, jaws = false);
        }
        crossbar(); droop_stop();
    }

// The fangs: two round fingers rooted on the head's front, leaning down it
// to tips lying on the bed, cut flat underneath.
module fangs()
    for (sd = [-1, 1]) intersection() {
        hull() {
            translate([sd * fang_x[0], head_y + fang_root[0], fang_root[1]]) sphere(fang_r[0], $fn = 32);
            translate([sd * fang_x[1], head_y + fang_tip - fang_r[1], fang_r[1] * sin(45)])
                sphere(fang_r[1], $fn = 32);
        }
        translate([-BIG / 2, -BIG, 0]) cube(2 * BIG);
    }

// Eight small eyes, dimpled into the front of the head.
module eyes() {
    // [x, y ahead of the head's centre]
    pts = [[-1.8, 11.0], [1.8, 11.0], [-5.4, 10.2], [5.4, 10.2],
           [-3.4, 8.0], [3.4, 8.0], [-7.4, 7.4], [7.4, 7.4]];
    for (p = pts) translate([p[0], head_y + p[1], head_z(p[0], p[1])]) sphere(eye_r, $fn = 16);
}

// A rough skin round the link from x0 to x1: spheres set along the round
// surface's normal, at an angle `a` round from its top, standing out as low
// bumps or sunk as shallow dents, of random size and depth. `seed` varies
// the pattern from link to link. rough(true) gives the bumps, rough(false)
// the dents.
module rough(x0, x1, seed, bumps) {
    r = rands(0, 1, 5 * rough_n, seed);
    for (i = [0 : rough_n - 1]) {
        bump = r[5 * i + 4] < 0.5;
        if (bump == bumps) {
            a   = (2 * r[5 * i + 1] - 1) * (bump ? bump_a : rough_a);
            y   = link_r * sin(a);
            z   = link_cz + link_r * cos(a);
            rad = rough_r[0] + (rough_r[1] - rough_r[0]) * r[5 * i + 2];
            d   = rough_d[0] + (rough_d[1] - rough_d[0]) * r[5 * i + 3];
            x   = x0 + (x1 - x0) * r[5 * i];
            // shrunk so none reaches the seams' sharp edges: behind, the
            // previous link's seam; ahead, this link's own (set back at the
            // sides, where it is swung)
            room = min(x - (seam_c + seam_v + z),
                       x1 - (seam_c + link_h) + (seam_c + z - abs(y) * sin(swing)) / cos(swing) - x) - 0.3;
            rr  = min(rad, room);
            dd  = min(d, rr / 4);
            if (rr >= rough_r[0] / 2)
                translate([x, y, z])
                    rotate([-a, 0, 0]) translate([0, 0, bump ? dd - rr : rr - dd]) sphere(rr, $fn = 24);
        }
    }
}

// One leg link: its tab round the origin, its own knuckle at x = pitch, or
// drawn out into a point on the bed if it is the claw. It butts up to the
// next link at a seam, and its rear is cut to the previous link's seam (or
// the head's niche).
module segment(last, seed = 1) {
    tab(); neck();
    difference() {
        union() {
            link_body(0, last ? body_x + 3 : pitch);
            // the foot: the link's full section, ending in a half ball
            if (last) intersection() {
                hull() {
                    link_body(body_x, body_x + claw_len - link_r);
                    translate([body_x + claw_len - link_r, 0, link_cz]) sphere(link_r, $fn = 48);
                }
                translate([0, -BIG / 2, 0]) cube(BIG);
            }
            else translate([pitch, 0, 0]) link_body(-0.01, seam_c + link_h + 1);
            // a rough skin, the whole length (the foot's up to its rounded
            // end); the seams cut it
            rough(0, last ? body_x + claw_len - link_r : pitch + seam_c + link_h, seed, true);
        }
        rough(0, last ? body_x + claw_len - link_r : pitch + seam_c + link_h, seed, false);
        seam_back();
        if (!last) translate([pitch, 0, 0]) { seam_front(); cavity(neck_roof, jaws = false); }
    }
    // the crossbar and the droop stop, inside the link's section and behind
    // the previous seam
    if (!last) difference() {
        translate([pitch, 0, 0]) intersection() {
            union() { crossbar(); droop_stop(); }
            link_body(-knuckle_r, knuckle_r);
        }
        seam_back();
    }
}

assert(head_wall >= roof_z + roof_min, "the head is too low to roof the sockets' mouths");
assert(head_wall >= ball_r + 0.8, "the head's rim is too low to stand over the legs' arches");
// Seen from the waist's crossbar, the head stays ahead of it however far the
// abdomen swings.
assert(asin(head_r / waist_at) + swing < 88, "the abdomen would swing into the head");
// The head reaches past the top of each socket's seam, so it is a niche.
assert(head_r - socket_at >= seam_c + seam_v + link_h, "the head stops short of the legs' niches");

assert(body_x < pitch + cavity_rear - 1, "the link is too short for its hood's cavity");
// The previous seam leaves the link tall enough over its cavity: over the
// tab's room, and behind it over the droop stop.
assert(pitch - stop_r - seam_c - seam_v >= roof_z + roof_min, "the seam cuts into the cavity's roof");
assert(pitch + cavity_rear - seam_c - seam_v >= stop_z + roof_min, "the seam cuts into the droop stop");

module leg(seed = 0)
    for (k = [0 : segments - 1])
        translate([k * pitch, 0, 0]) segment(k == segments - 1, 1 + 13 * seed + 101 * k);

module spider() {
    body();
    abdomen();
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) leg(i);
}

spider();
