// spider.scad — an articulated, print-in-place spider.
//
// One print, no assembly: a body with eight leg sockets, eight legs of
// links, and an abdomen on a ninth joint at the waist, its nose tucked
// under the head's back edge.
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
foot_end   = pitch + seam_c + link_h;  // how far the foot reaches past its
                    //   joint: as far as the top of any other link's front,
                    //   so the foot is as long as the other links
                    // the foot ends in a half ball, the link's own radius

// --- rough skin: random dents and bumps round every link ---
rough_n    = 120;   // per link
rough_r    = [1.5, 3];     // their radius, at random between: wide and
rough_d    = [0.15, 0.35]; //   shallow, so they run into each other
rough_a    = 80;    // dents reach this far round the link from its top, each
                    //   way (deg; 90 is its side), above where the underside
                    //   turns into an overhang
bump_a     = 50;    // bumps only this far, where they print without sagging
// the same skin on the body, as dense as on the legs; on the head only
// above the legs' arches (`ball_r` + 1), so it never reaches a cut edge
head_rough_n  = 600;
belly_rough_n = 450;
bump_from  = link_h + 1.5;  // the abdomen's bumps only above the legs'
                            //   tops, which swing past it
bump_back  = 50;    // no bumps on the head this far either side of straight
                    //   back (deg), where the abdomen hugs it

// --- body ---
head_r     = 25;    // the head's footprint, a disc on the bed: it reaches past
                    //   the top of each socket's seam, so the seam is a niche
                    //   in the head, under its full height
head_h     = 16;    // the head's height at its centre; the legs are `link_h`
head_n     = 3;     // the head's roundness: a flattened half ball, fuller
                    //   than an ellipse towards its edge, so it stands over
                    //   the legs' arches
head_y     = 0;     // cephalothorax centre
belly_tuck = 3;     // how far the abdomen's nose reaches in under the
                    //   head's back edge, on the bed
waist_at   = head_r - belly_tuck - seam_r - gap;  // the waist's crossbar,
                    //   behind the head's centre, inside the head: the head
                    //   is the hood, the abdomen hangs on it by a tab, and
                    //   its nose is cut to the seam the head's edge leans over
belly_rx   = 13;    // abdomen half-width
belly_ry   = 21;    // abdomen half-length
belly_h    = 18;    // abdomen height
belly_front = 6;    // the egg's front (its round top's tip), behind the
                    //   waist's crossbar, about under the head's edge; a
                    //   leg's link runs on from it, under the edge, to the seam
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

// The head's profile: a flattened half ball, a superellipse of exponent
// `head_n` (2 is an ellipse; more keeps it fuller towards its edge before
// it rounds down to the bed). Its height at a distance r from its centre.
function head_prof(r) = head_h * pow(max(1 - pow(min(r / head_r, 1), head_n), 0), 1 / head_n);
// The head's top at a point (x, y) from its centre.
function head_z(x, y) = head_prof(norm([x, y]));

// The cephalothorax: a flattened half ball standing on the bed, solid round
// the legs' sockets, so the first rings are inside it. Its side meets the
// bed upright, so its edge is not a knife edge. Convex, so drawn as a hull,
// which keeps the minkowski round it (cutting the abdomen) clean.
module head()
    translate([0, head_y, 0]) hull() rotate_extrude($fn = 128)
        polygon(concat([[0, 0]], [for (k = [0 : 47]) let(r = head_r * sin(90 * k / 48)) [r, head_prof(r)]], [[head_r, 0]]));

// The head and the fangs, with an arched cutout for each leg, as if a ball
// were taken out of the head where the leg leaves it, only past the leg's
// seam, so the head's back wall leans over the first link as a link's front
// does. Neighbouring balls run into each other, so nothing of the head comes
// down to the bed between the legs. Its back is cut to the seam at the
// waist, under its edge, where the abdomen's nose goes in; seen from above
// the head is whole.
module head_cut()
    difference() {
        union() { head(); fangs(); head_rough(true); }
        head_rough(false);
        for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) intersection() {
            seam_front(niche_swing, 2 * ball_r + 2);
            leg_ball();
        }
        at_waist() seam_front(swing, waist_w);
    }

// The ball: centred on the leg's line under the top of its seam, on the
// bed, big enough to take the first link, `gap` clear; drawn out past the
// head's rim, so it is an arched tunnel; swung through the niche.
ball_at = seam_c + seam_v + link_h;   // from the socket's crossbar
ball_r  = 9;                    // the arch's height: the first link's top
                                //   fits under it
waist_w = 2 * ball_r + 6;       // how wide the head's edge is lifted over the
                                //   abdomen's nose, swung through `swing`: past
                                //   the back legs' arches, so no pillar of head
                                //   (narrower) or thin ridge (as wide as an
                                //   arch) is left between them
module leg_ball()
    hull() for (t = [-niche_swing, niche_swing], x = [ball_at, head_r - socket_at + ball_r])
        rotate([0, 0, t]) translate([x, 0, 0]) sphere(ball_r, $fn = 96);

// The body's joints: the eight legs' sockets, then the waist (k = 8).
joints = 2 * len(leg_angles) + 1;
module at_joint(k) if (k < joints - 1) at_socket(k) children(); else at_waist() children();

// A joint's room in the solid head, like a link's cavity. A leg's is swept
// only a little past the niche, which stops the first link, and the full
// sweep only within the leg's width, where its rear drops as it droops; the
// waist's is swept the full `swing`, for the abdomen.
module joint_room(k)
    at_joint(k) if (k < joints - 1) {
        cavity(neck_roof, jaws = false, sw = 10);
        intersection() {
            cavity(neck_roof, jaws = false);
            translate([0, -link_w / 2, -1]) cube([BIG, link_w, BIG]);
        }
    } else cavity(neck_roof, jaws = false);

module body() {
    difference() {
        head_cut();
        for (k = [0 : joints - 1]) joint_room(k);
        eyes();
    }
    // each joint's crossbar and droop stop, kept out of its neighbours'
    // rooms (the sockets are close: a droop stop reaches the next one's)
    for (k = [0 : joints - 1]) difference() {
        at_joint(k) { crossbar(); droop_stop(); }
        for (j = [0 : joints - 1]) if (j != k) joint_room(j);
    }
}

// The waist: its crossbar on the centre line behind the head's centre,
// inside the head; +x points back, along the abdomen, as a leg's does.
module at_waist() translate([0, head_y - waist_at, 0]) rotate([0, 0, -90]) children();

// The abdomen, a separate piece: an egg on a tab and neck that hang on the
// waist's crossbar inside the head, so it swings, nods and twists like a
// leg's link on the one before. Its nose, a link wide, is cut to the
// seam, as a link's rear is, and goes in under the head's back edge, which
// leans over it; beside the nose it is cut round the head swung through
// `swing`.
module abdomen()
    at_waist() {
        tab(); neck();
        difference() {
            union() {
                translate([belly_front + belly_ry, 0, 0]) body_dome(belly_ry, belly_rx, belly_h);
                belly_rough(true);
            }
            belly_rough(false);
            for (t = [-swing : sweep_step : swing]) rotate([0, 0, t])
                rotate([0, 0, 90]) translate([0, waist_at - head_y, 0]) minkowski() {
                    head(); sphere(gap, $fn = 8);
                }
        }
        // the nose: a leg's link, cut to the seam, under the head's edge
        intersection() {
            link_body(0, belly_front + belly_ry / 2);
            seam_zone(seam_r + gap, seam_c + seam_v);
        }
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

// One spot of skin at a surface point p with outward normal n (unit): a
// sphere of radius rr standing out by dd as a bump, or sunk dd as a dent.
module skin_spot(p, n, rr, dd, bump)
    translate(p + n * (bump ? dd - rr : rr - dd)) sphere(rr, $fn = 24);

// A random spot's radius and depth, from two randoms.
function spot_r(u) = rough_r[0] + (rough_r[1] - rough_r[0]) * u;
function spot_d(u) = rough_d[0] + (rough_d[1] - rough_d[0]) * u;

// The eyes' patch on the head's front, kept smooth.
function by_eyes(x, y) = abs(x) < 10 && y > 4 && y < 14;

// The head's rough skin: spots scattered over its top, along the surface's
// normal, only above the arches' tops (clear of the arches and the waist's cut)
// and away from the eyes; no bumps over the back, where the abdomen is.
module head_rough(bumps) {
    r = rands(0, 1, 5 * head_rough_n, 7);
    for (i = [0 : head_rough_n - 1]) {
        bump = r[5 * i + 4] < 0.5;
        rad  = head_r * sqrt(r[5 * i]);
        th   = 360 * r[5 * i + 1];
        x    = rad * sin(th);       // th is a compass angle, from +y
        y    = rad * cos(th);
        z    = head_prof(rad);
        s    = (head_prof(rad + 0.05) - head_prof(rad - 0.05)) / 0.1;
        n    = [-s * sin(th), -s * cos(th), 1] / sqrt(1 + s * s);
        tilt = acos(n[2]);
        back = abs(th - 180) < bump_back;
        if (bump == bumps && z >= ball_r + 1 && !by_eyes(x, y)
            && tilt <= (bump ? bump_a : rough_a) && !(bump && back))
            translate([0, head_y, 0])
                skin_spot([x, y, z], n, spot_r(r[5 * i + 2]), spot_d(r[5 * i + 3]), bump);
    }
}

// The abdomen's rough skin, over its domed top (an ellipsoid on the dome's
// side), in the waist's frame like abdomen(); bumps only above the legs'
// tops and behind the head's reach, dents anywhere on the dome.
module belly_rough(bumps) {
    wall_h = belly_h * dome_from;
    c  = [belly_front + belly_ry, 0, wall_h];
    ax = [belly_ry, belly_rx, belly_h - wall_h];
    r  = rands(0, 1, 5 * belly_rough_n, 11);
    for (i = [0 : belly_rough_n - 1]) {
        bump = r[5 * i + 4] < 0.5;
        // a direction on the upper half of the unit sphere, evenly spread
        uz  = r[5 * i];
        ph  = 360 * r[5 * i + 1];
        u   = [sqrt(1 - uz * uz) * cos(ph), sqrt(1 - uz * uz) * sin(ph), uz];
        p   = c + [ax[0] * u[0], ax[1] * u[1], ax[2] * u[2]];
        m   = [u[0] / ax[0], u[1] / ax[1], u[2] / ax[2]];
        n   = m / norm(m);
        tilt = acos(n[2]);
        if (bump == bumps && tilt <= (bump ? bump_a : rough_a)
            && (!bump || (p[2] >= bump_from && p[0] >= belly_front + belly_ry / 2)))
            skin_spot(p, n, spot_r(r[5 * i + 2]), spot_d(r[5 * i + 3]), bump);
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
                    link_body(body_x, foot_end - link_r);
                    translate([foot_end - link_r, 0, link_cz]) sphere(link_r, $fn = 48);
                }
                translate([0, -BIG / 2, 0]) cube(BIG);
            }
            else translate([pitch, 0, 0]) link_body(-0.01, seam_c + link_h + 1);
            // a rough skin, the whole length (the foot's up to its rounded
            // end); the seams cut it
            rough(0, last ? foot_end - link_r : pitch + seam_c + link_h, seed, true);
        }
        rough(0, last ? foot_end - link_r : pitch + seam_c + link_h, seed, false);
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

assert(head_z(socket_at + seam_r, 0) >= roof_z + roof_min, "the head is too low to roof the sockets' mouths");
assert(head_z(socket_at + ball_at, 0) >= ball_r + 0.8, "the head is too low to stand over the legs' arches");
// The head roofs the waist's cavity and mouth, behind its edge.
assert(head_prof(waist_at + seam_r) >= neck_roof + roof_min, "the head is too low to roof the waist's mouth");
assert(head_prof(waist_at + neck_x + 0.5 + gap) >= roof_z + roof_min, "the head is too low to roof the waist's cavity");
// The head reaches past the top of each socket's seam, so it is a niche.
assert(head_r - socket_at >= seam_c + seam_v + link_h, "the head stops short of the legs' niches");

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
