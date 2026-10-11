// spider.scad — an articulated, print-in-place spider.
//
// One print, no assembly: a body with eight leg sockets, eight legs of
// links, and an abdomen on a ninth joint at the waist. Each joint is the hidden ring joint from joint.scad: a tab with a
// window on one link, threaded by a crossbar inside the hood of the next,
// ring through ring like a chain, so every link swings, nods and twists.
// Along a leg the links butt up to each other at 45 deg seams, and the first
// link sits in a niche in the head, cut to the same seam.
// Prints flat as exported, no supports.

include <joint.scad>

// --- legs ---
segments   = 4;     // leg segments per leg, the last one is the claw
leg_angles = [37, 71, 105, 139];  // leg directions, deg from straight ahead,
                                  //   evenly spaced, so the cavities between
                                  //   neighbouring sockets keep thick walls;
                                  //   mirrored for the left side
socket_at  = 13.5;  // distance of each socket's crossbar from the body
                    //   centre; its hood is the head itself
niche_swing = 3;    // how far a first link swings in its niche, each way
                    //   (plus the slack of the gap): a wider niche leaves the
                    //   head between neighbouring niches too thin
pitch      = 13.5;  // joint to joint along a leg; as short as it gets with
                    //   the previous seam leaving this link tall enough to roof its cavity
claw_len   = 8;     // how far the claw's point reaches past its shoulder

// --- body ---
head_r     = 23;    // the head's footprint, a disc on the bed: it reaches past
                    //   the top of each socket's seam, so the seam is a niche
                    //   in the head
head_wall  = 7;     // the head's straight side, up from the bed
head_h     = 14;    // the head's height at its centre; the legs are `link_h`
head_y     = 0;     // cephalothorax centre
sweep_step = 2.5;   // the head is cut away, straight down to the bed,
                    //   wherever the abdomen swings; the angle step of that
waist_at   = head_r - 2;  // the waist's crossbar, behind the head's centre:
                    //   its knuckle half out of the head's back, like the
                    //   coxae's, and the abdomen plugs into it like the next
                    //   link of a leg, right against the head
waist_from = 3;     // where the waist's hood starts, behind the head's centre
belly_rx   = 13;    // abdomen half-width
belly_ry   = 21;    // abdomen half-length
belly_h    = 18;    // abdomen height
belly_from = body_x - 1.5;  // the abdomen's front, from the waist's
                    //   crossbar: into the end of its first link
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

// Where the abdomen goes, in plan, in the waist's frame: its footprint, round
// the waist's knuckle, swung through `swing`.
module belly_room()
    offset(r = gap) for (t = [-swing : sweep_step : swing]) rotate(t) difference() {
        translate([belly_from + belly_ry, 0]) scale([belly_ry, belly_rx]) circle(1, $fn = 96);
        circle(r = wrap_r, $fn = 96);
    }

// The head and the fangs, with a niche for each leg cut to the seam, as a
// link's front is, and cut straight down wherever the abdomen moves.
module head_cut()
    difference() {
        union() { head(); fangs(); }
        for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) seam_front(niche_swing, link_w + 2 * gap);
        at_waist() translate([0, 0, -1]) linear_extrude(head_h + 2) belly_room();
    }

module body() {
    difference() {
        union() {
            head_cut();
            // the waist: a hood behind the head, from under it
            at_waist() hood_solid(waist_from - waist_at);
        }
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
        at_waist() cavity();
        eyes();
    }
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) { crossbar(); droop_stop(); }
    at_waist() { crossbar(); droop_stop(); }
}

// The waist: its crossbar on the centre line behind the head, the abdomen
// leaving straight back.
module at_waist() translate([0, head_y - waist_at, 0]) rotate([0, 0, -90]) children();

// The abdomen, a separate piece: an egg on the end of a link, whose tab
// hangs on the waist's crossbar, so it swings, nods and twists like a leg.
// Its front is hollowed round the waist's knuckle like a link's.
module abdomen()
    at_waist() {
        link_start(belly_from + 2);
        difference() {
            translate([belly_from + belly_ry, 0, 0]) body_dome(belly_ry, belly_rx, belly_h);
            wrap_hollow(belly_h + 2);
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

// One leg link: its tab round the origin, its own knuckle at x = pitch, or
// drawn out into a point on the bed if it is the claw. It butts up to the
// next link at a seam, and its rear is cut to the previous link's seam (or
// the head's niche).
module segment(last) {
    tab(); neck();
    difference() {
        union() {
            link_body(0, last ? body_x + 3 : pitch);
            if (last) hull() {
                link_body(body_x, body_x + 3);
                translate([body_x + claw_len - 0.5, 0, 0]) cylinder(r = 0.5, h = 1.2);
            }
            else translate([pitch, 0, 0]) link_body(-0.01, seam_c + link_h + 1);
        }
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
// The head reaches past the top of each socket's seam, so it is a niche.
assert(head_r - socket_at >= seam_c + seam_v + link_h, "the head stops short of the legs' niches");

assert(body_x < pitch + cavity_rear - 1, "the link is too short for its hood's cavity");
// The previous seam leaves the link tall enough over its cavity: over the
// tab's room, and behind it over the droop stop.
assert(pitch - stop_r - seam_c - seam_v >= roof_z + roof_min, "the seam cuts into the cavity's roof");
assert(pitch + cavity_rear - seam_c - seam_v >= stop_z + roof_min, "the seam cuts into the droop stop");

module leg()
    for (k = [0 : segments - 1])
        translate([k * pitch, 0, 0]) segment(k == segments - 1);

module spider() {
    body();
    abdomen();
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) leg();
}

spider();
