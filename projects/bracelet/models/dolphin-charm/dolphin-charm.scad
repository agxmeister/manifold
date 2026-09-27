// dolphin-charm — a chubby articulated dolphin whose tail bends every way, and a charm
// for the H-PIN mount.
//
// It snaps onto the upper half of an H-shaped pin (models/pin) whose lower
// half is already snapped into a pocket in a bracelet bar — like the other
// charms, with the same two holes (`charm_h_holes` in the lib).
//
// THE DOLPHIN LIES ACROSS THE BAND, spine along y, head at -y. The holes need
// a rigid block 14 mm long and 6.4 mm tall, so the CARRIER — the big round
// head with its pointed beak, the body, the dorsal fin and both flippers —
// is one solid over the band. Behind it the TAIL is `len(joints)` loose segments, the last one the
// fluke, and it hangs past the band's edge where it is free to move.
//
// THE JOINTS PRINT IN PLACE, and each is a pair of interlocked RINGS, like
// two links of a chain, so the tail bends up, down and sideways and twists a
// little. At each joint the front segment (A) ends in a WALL with a slot
// through it, and a CROSSBAR bridges the slot at mid height. The rear
// segment (B) reaches forward through the slot in a closed LOOP — a rail on
// the bed, an upright in a pocket in A, and a rail over the top — that hooks
// round the crossbar:
//
//          B's top rail over the crossbar: a BRIDGE, upright -> B's body
//        ______________________
//       |  |__________________|###########
//       |  |    |####|        |###  B  ###
//       |  |    |####|  <- A's crossbar: a BRIDGE across the slot,
//       |  |____|####|________|###    anchored on A's wall either side
//       |_______________________##########
//   ---------------------------------------- bed
//   upright   A's wall       B's front, a cone
//
// Nothing is cantilevered: B's bottom rail and upright stand on the bed, its
// top rail is a bridge from the upright to B's body, and the crossbar is a
// bridge between the two halves of A's wall, which stand on the bed. Every
// clearance is `bed_gap` sideways and `v_gap` vertically. A's rear and B's
// front are cones round the joint, each `bend`/2 back from square, and A's
// pocket and slot
// are sized for the loop swung `bend` degrees, so the joint bends `bend`
// degrees in any direction before anything but the loop meets.
//
// IT PRINTS SEAT DOWN, exactly as modelled, all segments at once, flat
// bottomed like the heart and the rose (the same trade: no backward bend on
// the two joints beside it). Every outer surface is a height field — the
// body's rings, and the flippers and fluke, each one surface inflated over a
// smooth outline — so none of them faces down. The fluke is TILTED UP
// `fluke_a` degrees about its root, so its flat underside is a ramp that
// grows off the bed, 90 - `fluke_a` from vertical. The dorsal fin's only
// overhang is its tip curling back, under 40 (asserted).

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ------------------------------------------------------------------- body
// The body's rings along the spine: [s, half-width, height]. Each ring is a
// superellipse, flat on the bed, `sect_p` its fullness.
body = [
    [-16.8, 0.35, 0.50],    // the beak's point — rounded, not a knife
    [-16.6, 0.85, 1.00],
    [-16.1, 1.05, 1.25],
    [-15.2, 1.30, 1.55],    // a slim beak, near constant: the rostrum
    [-14.0, 1.55, 1.90],
    [-12.8, 1.75, 2.20],
    [-12.1, 2.15, 2.75],    // the crease where the beak meets the melon
    [-11.3, 2.90, 3.60],    // from here the head swells steadily, its
    [-10.4, 3.55, 4.40],    //   growth only ever slowing (a row that grows
    [ -9.6, 4.05, 5.00],    //   slower than the next leaves a ridge round
    [ -8.8, 4.50, 5.55],    //   the head)
    [ -7.2, 5.30, 6.50],    // the head: smaller than the torso behind it
    [ -5.0, 6.10, 7.50],
    [ -2.0, 6.75, 8.20],
    [  1.0, 7.05, 8.60],
    [  3.5, 7.1, 8.7],      // the torso at its fullest, under the fin
    [  6.0, 6.8, 8.4],
    [  8.5, 6.2, 7.7],
    [ 10.5, 5.7, 7.0],
    [ 13.0, 5.1, 6.3],
    [ 16.0, 4.8, 5.9],
    [ 19.0, 4.6, 5.6],
    [ 22.0, 4.6, 5.3],
    [ 25.0, 4.6, 5.1],
    [ 27.5, 4.2, 4.6],
    [ 29.0, 3.0, 3.6],
    [ 30.2, 1.6, 2.7],      // ends inside the raised fluke (asserted)
];
sect_p  = 2.4;
ds      = 0.25;             // station step along the spine
n_sect  = 48;               // points round each ring

// the dorsal fin, stacked from ellipses, shaped like a real dolphin's: a
// long, gently convex leading edge, a rounded tip that curls back a little,
// and a steep, concave trailing edge that runs back into the body in a
// fillet. One row per height, [z, leading edge, trailing edge, half-
// thickness], smoothed by a Catmull-Rom spline; the first rows are sunk into
// the body. The trailing edge moving BACK as it rises is the only overhang
// (the curl), asserted under 40.
fin = [
    [ 6.8, -6.0, 6.6, 1.7],     // root, inside the body
    [ 8.4, -4.6, 6.4, 1.55],    // still under the body's back at the rear
    [ 9.0, -3.4, 5.0, 1.45],    //   so the trailing fillet grows out of it
    [ 9.6, -2.0, 4.3, 1.3],     // the leading edge climbs gently
    [10.4, -0.6, 4.0, 1.1],     // the trailing edge at its most forward
    [11.3,  1.0, 4.2, 0.9],
    [12.3,  2.6, 4.7, 0.75],    // the tip curls back
    [12.9,  3.6, 5.0, 0.62],
    [13.2,  4.1, 5.05, 0.52],   // the top, domed over
];
fin_cap = 0.35;             // the dome's height over the top row
fin_n   = 6;                // spline samples per row

// The flippers and the fluke are each ONE inflated surface, like the heart:
// a closed spline through `*_pts` (x, s) is the outline, and every ring of
// the surface is that outline scaled toward `*_mid` and raised on a
// superellipse profile, `*_h` high and `*_p` full. No hull, so no creases.
// The outline must be star-shaped about its middle (asserted).
flip_pts = [[ 4.0, -7.0], [ 7.0, -6.6], [10.5, -4.9], [13.2, -2.4],
            [14.8,  0.4], [14.6,  2.2], [13.0,  2.4], [10.4,  0.7],
            [ 7.6, -0.6], [ 4.5,  0.2], [ 3.2, -3.4]];  // right flipper, mirrored
flip_mid = [6.2, -3.2];
flip_h   = 2.6;
flip_p   = 2.0;

fluke_half = [[ 0.0, 27.3], [ 2.8, 27.7], [ 6.2, 29.2], [ 9.6, 31.0],
              [11.9, 32.9], [11.4, 34.5], [ 8.2, 34.8], [ 4.6, 34.3],
              [ 1.8, 33.2]];                           // right half, mirrored
// the lobes swept back: each point pushed back `fluke_sweep` per mm out from
// the middle, so the centreline (and the root) stays put — then the whole
// outline scaled by `fluke_scale` about the root, which keeps the sweep
fluke_sweep = 0.6;
fluke_scale = 0.75;
function fluke_sc(q) = [fluke_scale * q[0], fluke_half[0][1] + fluke_scale * (q[1] - fluke_half[0][1])];
fluke_sw  = [for (q = fluke_half) fluke_sc([q[0], q[1] + fluke_sweep * q[0]])];
fluke_pts = concat(fluke_sw, [fluke_sc([0, 32.2])],
                   [for (i = [len(fluke_sw) - 1 : -1 : 1]) [-fluke_sw[i][0], fluke_sw[i][1]]]);
fluke_mid = fluke_sc([0, 30.0]);
fluke_h   = 2.6;
fluke_p   = 2.2;
fluke_a   = 50;             // the fluke tilted up about its root, degrees:
                            //   its underside is 90 - this from vertical
fluke_skirt = 1.6;          // its rim, vertically — 1.0 across the tilt (at
                            //   1.0 the leading edge was 0.3 thick)
spl_n     = 12;             // spline samples between control points
infl_d    = 4;              // the profile's step, degrees

// dimples: eyes [s, z, radius, depth] and the blowhole [s, radius, depth]
eye      = [-7.6, 5.0, 0.95, 0.6];
blowhole = [-7.6, 0.5, 0.5];   // shallow: the head is low over the pin hole here

// ------------------------------------------------------------------ joints
joints  = [10.7, 18.2, 25.7];   // where the tail bends, along the spine
bend    = 25;           // how far each joint bends, any direction, degrees
bed_gap = 0.5;          // sideways clearance — two first-layer beads 0.3
                        //   apart weld, so 0.5 wherever parts share the bed
v_gap   = 0.5;          // vertical clearance over and under the crossbar
loop_w  = 1.8;          // B's loop, across (x)
rail_h  = 1.0;          // its bottom rail's height — 5 layers
rail_min = 0.9;         // the least of its top rail, under the body's top
up_t    = 1.0;          // its upright, along the spine
bar_t   = 1.2;          // A's crossbar, high
wall_t  = 1.4;          // A's wall (and crossbar), along the spine
swing_room = 0.7;       // extra pocket in front of the upright, which moves
                        //   along the spine as the joint bends up and down
horn_min = 1.0;         // the least of A's wall beside the slot and pocket
a_flat_r = 2.5;         // A's rear face is flat this far round the joint, so
                        //   the wall beside the slot keeps its full `wall_t`
                        //   (a cone right to the axis thinned it to 0.3); it
                        //   costs about a degree of `bend` there

// Along the spine, from the joint (the crossbar's middle):
slot_w  = loop_w + 2*bed_gap;           // 2.8 — the slot through A's wall
y_ur    = -wall_t/2 - bed_gap;          // -1.2 — the upright's rear face
y_uf    = y_ur - up_t;                  // -2.2 — and its front
y_b0    = wall_t/2 + bed_gap;           //  1.2 — B's cone starts
z_bar0  = rail_h + v_gap;               //  1.5 — the crossbar's underside
z_bar1  = z_bar0 + bar_t;               //  2.7 — its top
z_c     = (z_bar0 + z_bar1) / 2;        //  2.1 — the joint's centre
z_rail  = z_bar1 + v_gap;               //  3.2 — the top rail's underside
// A's pocket, half-width at its front: the upright swung `bend` either way
pocket_hw = loop_w/2 * cos(bend) + (up_t + bed_gap + wall_t/2 + swing_room) * sin(bend) + bed_gap;
y_pf    = y_uf - swing_room - bed_gap;  // -3.4 — the pocket's front
loop_r  = -y_pf - bed_gap;              //  2.9 — the loop's front, round the joint
big     = 100;

// ---------------------------------------------------------------- envelope
// A smooth cubic through the table (finite-difference Hermite): straight
// `lookup()` leaves a crease round the body at every row.
function seg_i(s, i = 0) = i >= len(body) - 2 || s < body[i + 1][0] ? i : seg_i(s, i + 1);
function slope_at(i, c) = let(a = max(i - 1, 0), b = min(i + 1, len(body) - 1))
    (body[b][c] - body[a][c]) / (body[b][0] - body[a][0]);
function prof(s, c) = let(
    i = seg_i(s), s0 = body[i][0], s1 = body[i + 1][0], d = s1 - s0,
    t = min(max((s - s0) / d, 0), 1), t2 = t*t, t3 = t2*t)
    (2*t3 - 3*t2 + 1) * body[i][c] + (t3 - 2*t2 + t) * d * slope_at(i, c)
  + (-2*t3 + 3*t2) * body[i + 1][c] + (t3 - t2) * d * slope_at(i + 1, c);
function bw(s) = prof(s, 1);
function bh(s) = prof(s, 2);
// the body's height at (x, s): 0 outside it
function env(x, s) = let(w = bw(s), h = bh(s))
    abs(x) >= w ? 0 : h * pow(1 - pow(abs(x)/w, sect_p), 1/sect_p);

// ------------------------------------------------------------------ checks
s_first = body[0][0];
s_last  = body[len(body) - 1][0];
// the least body height over a patch of plan
function env_min(x0, x1, y0, y1) = min([for (x = [x0 : (x1 - x0)/6 : x1 + 0.001],
                                             y = [y0 : 0.2 : y1 + 0.001]) env(x, y)]);
for (j = [0 : len(joints) - 1]) let(s = joints[j]) {
    // the top rail over the hole, under the body's top and the loop's disc
    assert(env_min(-loop_w/2, loop_w/2, s + y_ur, s + y_b0 + 1) >= z_rail + rail_min,
           str("joint ", j, ": the body is too low for the loop's top rail"));
    // A's wall beside the slot, and beside the pocket, at the bed
    assert(bw(s) - slot_w/2 >= horn_min,
           str("joint ", j, ": A's wall beside the slot is a sliver"));
    assert(bw(s + y_pf) - pocket_hw >= horn_min,
           str("joint ", j, ": A's wall beside the pocket is a sliver"));
    if (j > 0) assert(s - joints[j-1] + y_pf - y_b0 >= 2.5,
           str("joints ", j-1, " and ", j, " are too close: a segment has no middle"));
}
// the loop swung `bend` sideways still passes the slot
assert(loop_w/cos(bend) + wall_t*tan(bend) <= slot_w, "the slot is too narrow for the loop to swing");
assert(z_c + sqrt(loop_r*loop_r - y_ur*y_ur) >= z_rail + rail_min,
       "the loop's disc leaves too little top rail over the hole");
// the crossbar turns freely inside the loop's hole, any direction
assert(norm([wall_t/2, bar_t/2]) < min(wall_t/2 + bed_gap, bar_t/2 + v_gap),
       "the crossbar cannot turn inside the loop");
// the carrier's pocket must stay clear of the holes' walls
assert(joints[0] + y_pf >= hp_c_out + hp_wall + 0.2,
       "the first joint's pocket cuts into the pin holes' walls");
assert(max([for (r = fin) r[2]]) <= joints[0] + y_pf - 0.5, "the dorsal fin runs into the first joint");

echo(str("dolphin: joints at ", joints, ", pocket ", 2*pocket_hw, " wide from ", y_pf,
         ", slot ", slot_w, ", crossbar z ", z_bar0, "..", z_bar1));

// ---------------------------------------------------------------- the body
stations = [for (s = [s_first : ds : s_last]) s];
module body_env() {
    ns = len(stations);
    // a ring: the superellipse's top half, from +w to -w, then carried a
    // millimetre under the bed so the bed cut is the only face on z = 0 (a
    // flat bottom lying ON the cut leaves zero-thickness sheets where the
    // joint cuts cross it)
    pts = [for (s = stations) each concat(
        [for (i = [0 : n_sect])
            let(t = 180 * i / n_sect, c = cos(t), sn = sin(t))
            [bw(s) * sign(c) * pow(abs(c), 2/sect_p), s, bh(s) * pow(sn, 2/sect_p)]],
        [[-bw(s), s, -1], [bw(s), s, -1]])];
    m = n_sect + 3;
    polyhedron(pts, concat(
        [[for (i = [m - 1 : -1 : 0]) i]],                               // front cap
        [[for (i = [0 : m - 1]) (ns - 1)*m + i]],                       // back cap
        [for (k = [0 : ns - 2], i = [0 : m - 1])
            let(a = k*m + i, b = k*m + (i + 1) % m)
            [a, b, b + m, a + m]]));
}

// an ellipsoid centred on the bed: hulled and cut at z = 0 it is a height field
// A closed Catmull-Rom spline through `c`, `spl_n` samples per span.
function cr(p0, p1, p2, p3, t) = 0.5 * (2*p1 + (p2 - p0)*t
    + (2*p0 - 5*p1 + 4*p2 - p3)*t*t + (3*p1 - p0 - 3*p2 + p3)*t*t*t);
function spline(c) = let(n = len(c))
    [for (i = [0 : n - 1], k = [0 : spl_n - 1])
        cr(c[(i - 1 + n) % n], c[i], c[(i + 1) % n], c[(i + 2) % n], k / spl_n)];

// Star-shaped about `mid`: the bearing to the outline turns one way only.
function star_ok(o, mid) = let(n = len(o),
    b = [for (q = o) atan2(q[1] - mid[1], q[0] - mid[0])],
    d = [for (i = [0 : n - 1]) let(e = b[(i + 1) % n] - b[i]) e > 180 ? e - 360 : e < -180 ? e + 360 : e])
    max(d) < 0 || min(d) > 0;

// The outline inflated toward `mid`: rings scaled by cos^(2/p), raised by
// h sin^(2/p), from the bed to one crown point — plus a wall `skirt` under
// the bed, so the bed cut is the only face on z = 0. With `lift`, the
// whole surface is tilted up that many degrees about the line y = `root`:
// the plan is shortened by cos(lift) and every point raised by sin(lift)
// times its distance behind the root, so it stays a height field over its
// (tilted) bottom and the bottom is a plane `lift` degrees off the bed.
// Lifted, the skirt is no longer cut off: it is the rim's thickness.
module inflate(o, mid, h, p, lift = 0, root = 0, skirt = 1) {
    n = len(o);
    phis = [for (a = [0 : infl_d : 90 - infl_d]) a];
    nr = len(phis);
    function tilt(q) = let(d = q[1] - root)
        lift == 0 ? q : [q[0], root + d*cos(lift), q[2] + d*sin(lift)];
    pts = [for (q = concat(
        [for (q = o) [q[0], q[1], -skirt]],
        [for (a = phis, q = o) let(k = pow(cos(a), 2/p))
            [mid[0] + k*(q[0] - mid[0]), mid[1] + k*(q[1] - mid[1]), h * pow(sin(a), 2/p)]],
        [[mid[0], mid[1], h]])) tilt(q)];
    top = (nr + 1) * n;
    // the outline runs anticlockwise seen from above (`as_ccw`); CHECK THE
    // SIGNED VOLUME if this changes — inside out, it still exports NoError
    polyhedron(pts, concat(
        [[for (j = [0 : n - 1]) j]],
        [for (i = [0 : nr - 1], j = [0 : n - 1])
            let(a = i*n + j, b = i*n + (j + 1) % n) [a, a + n, b + n, b]],
        [for (j = [0 : n - 1]) [nr*n + j, top, nr*n + (j + 1) % n]]));
}
function ccw(o) = let(n = len(o))
    sum([for (i = [0 : n - 1]) o[i][0]*o[(i + 1) % n][1] - o[(i + 1) % n][0]*o[i][1]]) > 0;
function sum(v, i = 0) = i >= len(v) ? 0 : v[i] + sum(v, i + 1);
function as_ccw(o) = ccw(o) ? o : [for (i = [len(o) - 1 : -1 : 0]) o[i]];

flip_o  = as_ccw(spline(flip_pts));
fluke_o = as_ccw(spline(fluke_pts));
assert(star_ok(flip_o, flip_mid), "the flipper's outline is not star-shaped about its middle");
assert(star_ok(fluke_o, fluke_mid), "the fluke's outline is not star-shaped about its middle");
fluke_root = min([for (q = fluke_o) q[1]]);
assert(fluke_root >= joints[len(joints) - 1] + y_b0,
       "the fluke reaches forward into the segment in front");
// the tail stock must end INSIDE the raised fluke, not poke out under it:
// at its end its top is above the fluke's underside (x = 0)
assert(bh(s_last) >= (s_last - fluke_root) * tan(fluke_a) - fluke_skirt,
       "the tail stock pokes out under the raised fluke");

module flippers() for (m = [0, 1]) mirror([m, 0, 0]) inflate(flip_o, flip_mid, flip_h, flip_p);
module fluke() inflate(fluke_o, fluke_mid, fluke_h, fluke_p, fluke_a, fluke_root, fluke_skirt);

// the fin's rows sampled along an open Catmull-Rom spline (ends doubled):
// each sample [mid, half-chord, half-thickness, z]
fin_rows = [for (i = [0 : len(fin) - 2], k = [0 : fin_n - 1])
    cr(fin[max(i - 1, 0)], fin[i], fin[i + 1], fin[min(i + 2, len(fin) - 1)], k / fin_n),
    fin[len(fin) - 1]];
fin_sl = [for (r = fin_rows) [(r[1] + r[2])/2, (r[2] - r[1])/2, r[3], r[0]]];
// the curl: the trailing edge's backward lean between samples
assert(max([for (i = [0 : len(fin_rows) - 2])
        atan((fin_rows[i + 1][2] - fin_rows[i][2]) / (fin_rows[i + 1][0] - fin_rows[i][0]))]) <= 40,
       "the fin's trailing edge leans back past 40");
module fin_slice(f)
    translate([0, f[0], f[3]]) linear_extrude(0.01) scale([f[2], f[1]]) circle(1, $fn = 48);
module fin() {
    for (i = [0 : len(fin_sl) - 2])
        hull() { fin_slice(fin_sl[i]); fin_slice(fin_sl[i + 1]); }
    // a rounded tip: the top slice domed over by the cap of an ellipsoid
    // whose section there IS the slice — cut at 0.8 of its height, so it
    // meets the fin's sides at a slope, not vertical like a half-ellipsoid
    // (which read as a knob); all of it faces up
    let(f = fin_sl[len(fin_sl) - 1], c = fin_cap / 0.2)
        translate([0, f[0], f[3] - 0.8*c])
            intersection() {
                scale([f[2]/0.6, f[1]/0.6, c]) sphere(1, $fn = 48);
                translate([-5, -5, 0.8*c]) cube(10);
            }
}

module dimples() {
    ez = eye[1];
    ex = bw(eye[0]) * pow(1 - pow(ez / bh(eye[0]), sect_p), 1/sect_p);
    for (m = [-1, 1]) translate([m * (ex + eye[2] - eye[3]), eye[0], ez])
        sphere(eye[2], $fn = 24);
    translate([0, blowhole[0], env(0, blowhole[0]) - blowhole[2]])
        cylinder(r = blowhole[1], h = 5, $fn = 16);
}

module dolphin() difference() {
    intersection() {
        union() { body_env(); fin(); flippers(); fluke(); }
        translate([-big/2, -big/2, 0]) cube(big);
    }
    dimples();
}

// ------------------------------------------------------------------ joints
// A's pocket in plan, about the joint: the upright and the rails behind it,
// swung `bend` either way about the joint, with `swing_room` in front, grown
// by `bed_gap`. Plus the slot through the wall.
module pocket_2d() {
    // stopped at the wall's front face: grown into it, it leaves the wall
    // beside the slot a sliver
    intersection() {
        offset(r = bed_gap) hull() for (a = [-bend, 0, bend]) rotate(a)
            translate([-loop_w/2, y_uf - swing_room]) square([loop_w, -wall_t/2 - y_uf + swing_room]);
        translate([-big/2, -wall_t/2 - big]) square(big);
    }
    translate([-slot_w/2, -wall_t/2 - 0.01]) square([slot_w, wall_t + 0.02]);
}

// The two faces either side of a joint are cones round it, each `bend`/2
// back from square: turned `bend` degrees, one lies parallel to the other.
module cone() cylinder(h = big, r1 = 0, r2 = big * tan(90 - bend/2), $fn = 96);

// What A keeps at joint j: everything up to its wall's rear face — flat out
// to `a_flat_r` round the joint, a cone beyond — less the pocket and slot through its full
// height, plus the crossbar across the slot.
module a_keep(j) translate([0, joints[j], 0]) {
    difference() {
        intersection() {
            translate([0, wall_t/2 + a_flat_r * tan(bend/2), z_c]) rotate([90, 0, 0]) cone();
            translate([-big/2, wall_t/2 - big, -1]) cube(big);
        }
        translate([0, 0, -2]) linear_extrude(big) pocket_2d();
    }
    translate([-slot_w/2 - 0.5, -wall_t/2, z_bar0]) cube([slot_w + 1, wall_t, bar_t]);
}

// What B keeps at joint j: a cone with its tip
// `y_b0` behind the joint, plus the loop — a bar `loop_w` wide from the
// upright's front back into B's body, less the hole round the crossbar.
module b_keep(j) translate([0, joints[j], 0]) {
    translate([0, y_b0, z_c]) rotate([-90, 0, 0]) cone();
    difference() {
        intersection() {
            translate([-loop_w/2, y_uf, -1]) cube([loop_w, y_b0 + 2 - y_uf, big]);
            // in front of the joint, a disc round its axis: bending up or
            // down then never swings the loop toward the pocket's front (a
            // square upright reached it at 20 degrees under the tall head)
            union() {
                translate([0, 0, z_c]) rotate([0, 90, 0]) cylinder(r = loop_r, h = big, center = true, $fn = 96);
                translate([-big/2, 0, -1]) cube(big);
            }
        }
        translate([-loop_w, y_ur, rail_h]) cube([2*loop_w, y_b0 + 3 - y_ur, z_rail - rail_h]);
    }
}

// Segment k: 0 is the carrier, len(joints) the fluke.
module segment(k) {
    n = len(joints);
    difference() {
        intersection() {
            dolphin();
            if (k > 0) b_keep(k - 1); else translate([-big/2, -big/2, -1]) cube(big);
            if (k < n) a_keep(k);     else translate([-big/2, -big/2, -1]) cube(big);
        }
        if (k == 0) charm_h_holes();
    }
}

module dolphin_charm() for (k = [0 : len(joints)]) segment(k);

dolphin_charm();
