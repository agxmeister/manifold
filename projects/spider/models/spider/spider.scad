// spider.scad — an articulated, print-in-place spider.
//
// One print, no assembly: a body with eight leg sockets, eight legs of
// links, and an abdomen on a ninth joint at the waist, its nose tucked
// under the head's back edge.
// Each joint is the ring joint from joint.scad: an upright ring (a tab with
// a window) on one link, through a ring lying round a roofed hole in the
// next (its crossbar through the window), like a chain, both hidden, so
// every link swings, nods and twists. Along a leg the links butt up to each other at upright seams; the
// first link sits in a niche in the head whose back leans over it at 45 deg,
// the head's underside rising on at 45 deg out to its edge over the legs.
// Prints flat as exported, no supports.

include <joint.scad>

// --- legs ---
segments   = 4;     // leg segments per leg, the last one is the claw
leg_angles = [25, 58, 94, 155];  // leg directions, deg from straight ahead,
                                 //   fanned out like a real spider's: the
                                 //   front pair reaching forward, the back
                                 //   pair back beside the abdomen; mirrored
                                 //   for the left side
socket_angles = [32, 68, 102, 140];  // where each leg's socket sits round
                    //   the head, deg from straight ahead: a leg leaves the
                    //   head's side, not its centre, so the back pair start
                    //   from its back corners, either side of the waist
socket_at  = 13;    // distance of each socket's crossbar from the body
                    //   centre; the head is solid round it
niche_swing = 3;    // how far a first link swings in its niche, each way
                    //   (plus the slack of the gap), under the head's lean
pitch      = 13.5;  // joint to joint along a leg
leg_bend   = [[15, 15, 15], [5, 5, 5], [15, 20, 15], [14, 2, 20]];
                    // each leg is printed bent at its joints, a link on the
                    //   one before, deg toward the back (minus: toward the
                    //   front), like a resting spider's, so the legs draw in
                    //   round the abdomen; the joints swing ±`swing` from
                    //   straight, so a bent joint swings on from there
foot_end   = pitch + seam_r;  // how far the foot reaches past its joint: as
                    //   far as any other link's front, so the foot is as long
                    //   as the other links
                    // the foot ends in a half ball, the link's own radius

// --- curvy skin: smooth, wide swells over every link and the body ---
// Swells set at random, summed and softly capped, so they run into each
// other as gentle waves with no edge or crease. Only ever added, never cut
// in, so no wall or roof gets thinner; faded out near the bed, the seams
// and the cut edges, where the shape must stay exact.
swell_h    = 0.8;   // how high a link's skin rises at most (mm)
swell_s    = [2.5, 3.5];  // a swell's spread (sigma, mm), at random between
leg_swells = 10;    // per link, half swells, half hollows
swell_a    = [20, 55];    // round a link from its top (deg): full swells up
                    //   to the first, none past the second; lower down a
                    //   swell's flank would face the bed and sag
head_swells  = 60;  // scattered over the head, half swells, half hollows
belly_swells = 60;
body_swell_h = 1.0; // on the head and the abdomen
body_swell_s = [3.0, 4.5];
swell_from = 10;    // the head's swells only above where its lean over the
                    //   legs comes out at its side (about 9 mm up)
belly_from = 8.5;   // the abdomen's only above the legs' tops, which swing
                    //   past it, and only on its back part
swell_back = [50, 70];  // none on the head's outer part (`swell_rim` out)
                        //   this far either side of straight back (deg),
                        //   where the abdomen hugs it; full past the second
swell_rim  = [15, 18];

// --- body ---
head_r     = 22;    // the head's footprint, a disc on the bed: it reaches past
                    //   the top of each socket's seam, so the seam is a niche
                    //   in the head, under its full height
head_h     = 14;    // the head's height at its centre; the legs are `link_h`
head_n     = 3;     // the head's roundness: a flattened half ball, fuller
                    //   than an ellipse towards its edge, so it stands over
                    //   the legs
head_y     = 0;     // cephalothorax centre
belly_tuck = 3;     // how far the abdomen's nose reaches in under the
                    //   head's back edge, on the bed
waist_at   = head_r - belly_tuck - seam_r - gap;  // the waist's crossbar,
                    //   behind the head's centre, inside the head: the
                    //   head holds the crossbar, the abdomen hangs on it by a tab, and
                    //   its nose is cut to the seam the head's edge leans over
belly_rx   = 11;    // abdomen half-width
belly_ry   = 17;    // abdomen half-length
belly_h    = 15;    // abdomen height
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
function socket_dir(i) = i < len(socket_angles) ? socket_angles[i]
                                                : -socket_angles[i - len(socket_angles)];
// Compass angle (deg from +y, clockwise) -> OpenSCAD rotation about z
// that turns +x onto it.
function rot(a) = 90 - a;
function socket_pos(i) = socket_at * [sin(socket_dir(i)), cos(socket_dir(i)), 0];
// A point r out along socket i's leg from its crossbar, in plan.
function along(i, r) = [socket_pos(i)[0], socket_pos(i)[1]] + r * [sin(leg_dir(i)), cos(leg_dir(i))];

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

// The head and the fangs, cut to each leg's seam, `lean_w` wide: the head's
// back wall stands up to `seam_up` and then leans over the first link at
// 45 deg, as a link's front does, and goes on leaning out to the head's side,
// so its whole underside over the legs grows off the wall below it, layer by
// layer, with nothing hanging (round arches here had flat crowns and cusps
// between them hanging in the air). Neighbouring leans run into each other,
// so nothing of the head comes down to the bed between the legs. Its back is
// cut to the seam at the waist the same way, under its edge, where the
// abdomen's nose goes in; seen from above the head is whole.
module head_cut()
    difference() {
        union() { head(); fangs(); head_swells(); }
        for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i)
            let(w = lean_w[i % len(leg_angles)]) lean(i < len(leg_angles) ? w : [w[1], w[0]]);
        at_waist() seam_front(swing, waist_w, seam_up);
    }

lean_w  = [[10, 6], [10, 10], [10, 10], [6, 14]];
                                // how far the head leans over each leg either
                                //   side of it, [behind, ahead]: wide enough
                                //   that neighbouring legs' leans meet, so no
                                //   pillar of head is left between them, but
                                //   narrow on the front pair's inner side, for
                                //   the fangs, and on the back pair's, for the
                                //   waist's cheeks
// A leg's lean: the seam's front swung through `niche_swing`, `sides` wide
// either side of the leg ([-y, +y] in the socket's frame: on the right side
// +y is the leg's front side, on the mirrored left side its back).
module lean(sides)
    for (t = [-niche_swing : 1 : niche_swing]) rotate([0, 0, t])
        translate([0, (sides[1] - sides[0]) / 2, 0]) seam_zone(seam_r, seam_up, sides[0] + sides[1]);
waist_w = 12;                   // how wide the head's edge is lifted over the
                                //   abdomen's nose, swung through `swing`: no
                                //   wider, or it cuts away the head round the
                                //   back legs' sockets, either side of it

// The body's joints: the eight legs' sockets, then the waist (k = 8).
joints = 2 * len(leg_angles) + 1;
module at_joint(k) if (k < joints - 1) at_socket(k) children(); else at_waist() children();

// A joint's room in the solid head, a link's hole under a cone. A leg's is swept
// only a little past the niche, which stops the first link, and the full
// sweep only within the leg's width, where its rear drops as it droops; the
// waist's is swept the full `swing`, for the abdomen.
module joint_room(k)
    at_joint(k) if (k < joints - 1) {
        cavity(true, sw = 10);
        intersection() {
            cavity(true);
            translate([0, -link_w / 2, -1]) cube([BIG, link_w, BIG]);
        }
    } else cavity(true);

module body() {
    difference() {
        head_cut();
        for (k = [0 : joints - 1]) joint_room(k);
        eyes();
    }
    // each joint's crossbar, kept out of its neighbours' rooms (the sockets
    // are close together)
    for (k = [0 : joints - 1]) difference() {
        at_joint(k) crossbar();
        for (j = [0 : joints - 1]) if (j != k) joint_room(j);
    }
}

// The waist: its crossbar on the centre line behind the head's centre,
// inside the head; +x points back, along the abdomen, as a leg's does.
module at_waist() translate([0, head_y - waist_at, 0]) rotate([0, 0, -90]) children();

// The abdomen, a separate piece: an egg on a tab that hangs on the
// waist's crossbar inside the head, so it swings, nods and twists like a
// leg's link on the one before. Its nose, a link wide, is cut to the
// seam, as a link's rear is, and goes in under the head's back edge, which
// leans over it; beside the nose it is cut round the head swung through
// `swing`.
module abdomen()
    at_waist() {
        tab();
        difference() {
            union() {
                translate([belly_front + belly_ry, 0, 0]) body_dome(belly_ry, belly_rx, belly_h);
                belly_swells();
            }
            for (t = [-swing : sweep_step : swing]) rotate([0, 0, t])
                rotate([0, 0, 90]) translate([0, waist_at - head_y, 0]) minkowski() {
                    head(); sphere(gap, $fn = 8);
                }
        }
        // the nose: a leg's link, cut to the seam, under the head's edge
        difference() {
            intersection() {
                link_body(0, belly_front + belly_ry / 2);
                seam_zone(seam_r + gap, seam_up + gap - seam_v);
            }
            bevels(seam_r + gap, false);
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

// --- the curvy skin ---------------------------------------------------------

// 0 at e0 rising smoothly to 1 at e1 (either way round).
function ramp(e0, e1, x) = let(t = min(max((x - e0) / (e1 - e0), 0), 1)) t * t * (3 - 2 * t);

// n random swells and hollows over the patch u x v: [u, v, height (+ a
// swell, - a hollow), spread].
function swells(n, u, v, h, s, seed) =
    let(r = rands(0, 1, 4 * n, seed))
    [for (i = [0 : n - 1]) [u[0] + (u[1] - u[0]) * r[4 * i], v[0] + (v[1] - v[0]) * r[4 * i + 1],
                            h * (r[4 * i + 2] < 0.5 ? -1 : 1) * (0.6 + 1.2 * abs(r[4 * i + 2] - 0.5)),
                            s[0] + (s[1] - s[0]) * r[4 * i + 3]]];

// The skin's rise at (u, v), `lo` to h: the swells and hollows summed
// and squeezed smoothly into that range, so where they crowd together they
// run into one gentle rise or dip rather than a peak.
function rise(sw, u, v, h, lo = skin_min) =
    let(t = [for (b = sw) b[2] * exp(-(pow(u - b[0], 2) + pow(v - b[1], 2)) / (2 * b[3] * b[3]))])
    lo + (h - lo) / (1 + exp(-3 * (t * [for (b = sw) 1]) / h));

// On the head and the abdomen the skin is a cap laid over the plain shape.
// How far out it stands at a point with fade weight w and rise d. Faded
// out it lies `skin_in` inside the plain surface, and a hollow's bottom stays
// `skin_min` out of it, so the skin crosses the surface only in the fades,
// cleanly, never grazing it (grazing leaves loose crumbs in the union).
skin_in  = 0.2;
skin_min = 0.2;
function skin(w, d) = w * (d + skin_in) - skin_in;

// A cap over a surface with a centre: rings[k][j] its top, ring after ring
// out from `top` (all rings the same length, going round counter-clockwise
// seen from above), closed by upright sides down to a flat floor at zb.
module skin_cap(top, rings, zb) {
    nr = len(rings);
    nt = len(rings[0]);
    last = rings[nr - 1];
    pts = concat([top], [for (ring = rings) each ring],
                 [for (p = last) [p[0], p[1], zb]], [[top[0], top[1], zb]]);
    T = function(k, j) 1 + k * nt + (j % nt);
    B = function(j) 1 + nr * nt + (j % nt);
    bc = 1 + nr * nt + nt;
    polyhedron(pts, concat(
        [for (j = [0 : nt - 1]) [0, T(0, j + 1), T(0, j)]],
        [for (k = [0 : nr - 2], j = [0 : nt - 1]) [T(k, j), T(k, j + 1), T(k + 1, j + 1), T(k + 1, j)]],
        [for (j = [0 : nt - 1]) [T(nr - 1, j), T(nr - 1, j + 1), B(j + 1), B(j)]],
        [for (j = [0 : nt - 1]) [bc, B(j), B(j + 1)]]));
}

// A link's block from 0 to x1, its round top lifted by the swells. It is the
// link's own surface, not a skin laid over it, so the swells run into the
// plain link with no edge. They fade out round the flanks (`swell_a`) and
// over 3 mm into xa and xb, clear of the seams' edges; seed 0: plain.
module curvy_link(x1, xa, xb, seed) {
    vm = link_r * swell_a[1] * PI / 180;
    sw = seed ? swells(leg_swells, [xa - 1, xb + 1], [-vm, vm], swell_h, swell_s, seed) : [];
    nx = ceil(x1 / 0.3);
    m  = link_n + 3;    // points round the section
    pts = [for (i = [0 : nx]) let(x = x1 * i / nx, wx = ramp(xa, xa + 3, x) * ramp(xb, xb - 3, x))
        each [for (p = link_pts(function(a) seed && wx > 0
                      ? wx * ramp(swell_a[1], swell_a[0], abs(a - 90))
                           * rise(sw, x, link_r * (90 - a) * PI / 180, swell_h, 0)
                      : 0)) [x, p[0], p[1]]]];
    P = function(i, j) i * m + (j % m);
    polyhedron(pts, concat(
        [for (i = [0 : nx - 1], j = [0 : m - 1]) [P(i, j), P(i + 1, j), P(i + 1, j + 1), P(i, j + 1)]],
        [[for (j = [0 : m - 1]) P(0, j)], [for (j = [m - 1 : -1 : 0]) P(nx, j)]]));
}

// The head's skin: its top above the legs' arches, lifted by the swells
// (straight up, it is nearly flat there), fading in over 2 mm above
// `swell_from`; none over the back, where the abdomen is, nor round the eyes.
module head_swells() {
    ze = swell_from - 1;    // the cap's edge, well below its swells
    zb = ze - 1;            // and its floor, under the edge
    rm = head_r * pow(1 - pow(ze / head_h, head_n), 1 / head_n);
    sw = swells(head_swells, [-head_r, head_r], [-head_r, head_r], body_swell_h, body_swell_s, 7);
    nr = 48;
    rings = [for (k = [1 : nr]) [for (j = [0 : 119])
        let(r = rm * k / nr, th = 360 - 3 * j,  // compass angle, from +y
            x = r * sin(th), y = r * cos(th), z = head_prof(r),
            w = ramp(swell_from, swell_from + 2, z)
              * (1 - (1 - ramp(swell_back[0], swell_back[1], abs(th - 180))) * ramp(swell_rim[0], swell_rim[1], r))
              * ramp(1, 2.2, norm([x / 9, (y - 9.2) / 4])))
        [x, y, z + skin(w, rise(sw, x, y, body_swell_h))]]];
    translate([0, head_y, 0]) skin_cap([0, 0, head_h + rise(sw, 0, 0, body_swell_h)], rings, zb);
}

// The abdomen's skin: its dome above the legs' tops (`belly_from`), on its
// back part, pushed out along the dome's normal by the swells (its sides are
// steep); clear of where it is cut round the head. In the waist's frame,
// like abdomen().
module belly_swells() {
    wall_h = belly_h * dome_from;
    hz = belly_h - wall_h;
    cx = belly_front + belly_ry;
    ze = belly_from - 1;
    zb = ze - 1;
    pm = sqrt(1 - pow((ze - wall_h) / hz, 2));
    sw = swells(belly_swells, [cx - belly_ry, cx + belly_ry], [-belly_rx, belly_rx],
                body_swell_h, body_swell_s, 11);
    wf = function(x, z) ramp(belly_from, belly_from + 5, z)
                      * ramp(belly_front + 0.55 * belly_ry, belly_front + 0.9 * belly_ry, x);
    nr = 40;
    rings = [for (k = [1 : nr]) [for (j = [0 : 119])
        let(p = pm * k / nr, f = 3 * j,
            x = cx + belly_ry * p * cos(f), y = belly_rx * p * sin(f),
            z = wall_h + hz * sqrt(1 - p * p),
            m = [cos(f) * p / belly_ry, sin(f) * p / belly_rx, sqrt(1 - p * p) / hz],
            n = m / norm(m))  // the dome's normal
        ([x, y, z] + n * skin(wf(x, z), rise(sw, x, y, body_swell_h)))]];
    skin_cap([cx, 0, belly_h + skin(wf(cx, belly_h), rise(sw, cx, 0, body_swell_h))], rings, zb);
}

// One leg link: its tab round the origin, its own hole and crossbar at
// x = pitch, or drawn out into a foot if it is the last. It butts up to the
// next link at a seam, and its rear is cut to the previous link's seam (or,
// the first, to the head's niche).
module segment(first, last, seed = 1) {
    up = first ? seam_up : BIG;
    tab();
    difference() {
        union() {
            // the link, curvy but for the first, which is mostly in the head
            curvy_link(last ? foot_end - link_r : pitch + seam_r + 1, seam_rear(link_h) + 0.3,
                       last ? foot_end - link_r : pitch + seam_r - link_r * sin(swing) - 0.3,
                       first ? 0 : seed);
            // the foot: the link's full section, ending in a half ball
            if (last) intersection() {
                hull() {
                    link_body(link_x, foot_end - link_r);
                    translate([foot_end - link_r, 0, link_cz]) sphere(link_r, $fn = 48);
                }
                translate([0, -BIG / 2, 0]) cube(BIG);
            }
        }
        seam_back(up);
        if (!last) translate([pitch, 0, 0]) { seam_front(); cavity(); }
    }
    if (!last) translate([pitch, 0, 0]) crossbar();
}
link_x = seam_r + gap;   // the link's rear, behind its tab

// The head is high enough over its rooms' cones, and over the legs' arches.
for (r = [0 : 0.5 : room_front + body_ext]) {
    for (i = [0 : len(leg_angles) - 1])
        assert(head_z(along(i, r)[0], along(i, r)[1]) >= cone_top - r + roof_min, "the head is too low over the sockets' rooms");
    assert(head_prof(waist_at + r) >= cone_top - r + roof_min, "the head is too low over the waist's room");
}
// The head reaches past the top of each socket's seam, so it is a niche.
for (i = [0 : len(leg_angles) - 1]) let(p = along(i, seam_rear(link_h, seam_up)))
    assert(head_z(p[0], p[1] - head_y) >= link_h + 1, "the head stops short of the legs' niches");
// A link is solid between its rear and its hole.
assert(pitch - stop_r - seam_rear(link_h, seam_up) >= 2, "the link is too short between its rear and its hole");
// The crossbar's ends stay in the cheeks, clear of the next link's swept rear.
assert((seam_r - bar_len / 2 * sin(swing)) / cos(swing) >= bar_w / 2, "the crossbar sticks out of the cheeks");

// Leg i from its k-th link out, each link printed swung by its bend on the
// one before (toward the back on both sides, so the mirrored left side bends
// the other way round in its own frame).
module leg(i, k = 0)
    if (k < segments) {
        segment(k == 0, k == segments - 1, 1 + 13 * i + 101 * k);
        translate([pitch, 0, 0]) rotate([0, 0, (i < len(leg_angles) ? -1 : 1) * bend(i, k + 1)])
            leg(i, k + 1);
    }
function bend(i, k) = k < segments ? leg_bend[i % len(leg_angles)][k - 1] : 0;
for (b = leg_bend, t = b)
    assert(abs(t) <= swing - 5, "a leg is bent too far to swing on from there");

module spider() {
    body();
    abdomen();
    for (i = [0 : 2 * len(leg_angles) - 1]) at_socket(i) leg(i);
}

spider();
