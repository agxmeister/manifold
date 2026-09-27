// rose-charm — a rose with thin, ruffled petals, and a charm for the H-PIN
// mount.
//
// It snaps onto the upper half of an H-shaped pin (models/pin) whose lower
// half is already snapped into a pocket in a bracelet bar — like the
// butterfly, the ladybug and the heart, with the same two holes
// (`charm_h_holes` in the lib).
//
// THE ROSE. A solid CORE — a low dome — carries the holes. Out of its top
// rises the BUD, three petals wrapped round an open middle, and round it
// stand three rings of open PETALS, each shingled: every petal starts inside
// its neighbour and ends outside the next. The petals are thin shells
// (`petal_t`), and above the core they stand free: rounded tops dipping
// between petals, a wave along the lip, pleats that deepen toward the lip,
// and a flare that opens outward as they rise, more the further out.
//
// NO TWO PETALS GRAZE. Two thin walls that cross at a shallow angle, or run
// side by side a hair apart, leave a slit too narrow to print and slivers
// too thin to lay down — the first version of this rose was full of them.
// So within a ring, neighbours overlap by a fixed step and are FUSED
// (`ring_fuse`), their pleats die away where they overlap, and between rings
// there is always real air (`ring_gap`) — both asserted. The flare grows
// ring by ring, so the gaps only open as the petals rise.
//
// EVERY PETAL IS A HEIGHT FIELD IN RADIUS. A petal is described by where its
// inner face sits, r(theta, z), so every horizontal slice through it is an
// arc of wall. Its inner face only ever faces up (it moves outward as it
// rises); its outer face leans out at most `flare_max` from vertical,
// asserted, so every layer lands on the one below. Its top is a lip, all
// floor. Nothing needs support.
//
// THE OUTER PETALS ARE THICK AT THE FOOT AND THIN ABOVE, like real ones.
// Up to their `web` height — the core's whole side — their inner face is
// carried in to the core, so from outside the rose is petals all the way
// down, never the core's side. Above it the petal thins out at a slope
// that faces up, while the core's dome falls away from it: the groove
// between them opens at once instead of peeling apart as a slit.
//
// IT PRINTS SEAT DOWN, exactly as modelled. The bottom is flat to the edge,
// like the heart and the ladybug: it rests on the neighbouring bars, so the
// wearing direction is free and the two joints beside it do not bend
// backwards past flat — the trade the heart and the ladybug already make.
// The petals flare outward only above the bed, so they never reach under a
// neighbour's knuckle.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ------------------------------------------------------------------ the rose
petal_t   = 0.9;            // a petal's thickness — two lines on a 0.4 nozzle
flare_max = 42;             // the most any petal's outer face leans out from
                            //   vertical — self-supporting under 45
web_slope = 60;             // the web's inner face, from vertical — faces up

// The core: a flat-sided dome, solid, that the holes are sunk into.
core_r    = 8.0;            // its radius
core_side = 6.95;           // the height of its side — 6.6 until the
                            //   2026-09-27 pin raised the holes' gables 0.35
core_top  = 7.95;           // and of its crown

// The rings, from the middle out. Each row is one ring of `n` petals:
//   [n, span, r_start, r_end, z_base, top, side, lean0, lean1, turn, wave,
//    pleat, web]
// `span` is each petal's arc in degrees, a little more than 360/n so that
// neighbours overlap; `r_start`..`r_end` is its inner radius across that
// arc, so each petal ends outside the start of the next (the shingling);
// `top` and `side` its lip height at the middle and at the edges; `lean*`
// its lean out from vertical at the foot and at the lip; `turn` where the
// ring starts; `wave` the lip's rise and fall; `pleat` how far the petal
// ripples in and out at its lip; `web` the height up to which it is fused
// solid to the core (0: it grows out of the core instead of the bed).
rings = [
    [3, 150, 1.30, 1.90, 5.0, 10.3,  8.8, -6,  4,  20, 0.25, 0.05, 0.0],  // the bud
    [5,  90, 3.40, 4.00, 4.0, 10.0,  7.9,  2, 16,  70, 0.35, 0.15, 0.0],  // inner ring
    [5,  90, 5.65, 6.25, 3.0,  9.7,  7.1,  4, 18,  34, 0.40, 0.20, 0.0],  // middle ring
    [6,  75, 8.05, 8.65, 0.0,  9.0,  5.6,  6, 16,   0, 0.45, 0.30, 6.95],  // outer ring
];
ring_fuse = 0.3;            // the least wall two neighbours in a ring share
ring_gap  = 0.4;            // and the least air between two rings, at the foot
dump = false;               // echo every petal's record, for the gap scan

n_u = 40;                   // stations across a petal
n_v = 18;                   // and up it

// ------------------------------------------------------------ petal records
// A petal as one record:
//   [th0, span, r_start, r_end, z_base, top, side, lean0, lean1, wave, pleat,
//    web, lap]
// `lap` is the fraction of its arc shared with a neighbour at either end.
recs = [for (g = rings, p = [0 : g[0] - 1])
    [g[9] + p * 360 / g[0], g[1], g[2], g[3], g[4], g[5], g[6], g[7], g[8],
     g[10], g[11], g[12], (g[1] - 360 / g[0]) / g[1]]];
if (dump) for (g = recs) echo(petal = g);

// ----------------------------------------------------------------- the petal
// The flare: lean `a0` at the foot, `a1` at the lip, linear in height, so
// the offset it builds up is the integral of tan — closed form.
function lean(z, h, a0, a1) = a0 + (a1 - a0) * min(1, max(0, z / h));
function flare(z, h, a0, a1) =
    let(k = (a1 - a0) / h, zz = min(max(z, 0), h))
    abs(k) < 1e-6 ? zz * tan(a0)
                  : (ln(cos(a0)) - ln(cos(a0 + k*zz))) / (k * PI/180)
                    + max(0, z - h) * tan(a1);

// A petal's lip height at u in [-1, 1] across its arc.
function lip(u, top, side, wave) =
    side + (top - side) * sqrt(max(0, 1 - u*u)) + wave * sin(540 * u) * (1 - u*u);

// Its inner face at (u, z), and the thickness it has outward from it. The
// pleat is two ripples across the part of the petal it shares with no
// neighbour, so where two petals overlap they never ripple into each other.
function pleat(s, lap) = let(q = (s - lap) / (1 - 2*lap))
    q <= 0 || q >= 1 ? 0 : sin(720 * q) * sin(180 * q);
function r_in(u, z, g) =
    let(ra = g[2], rb = g[3], zb = g[4], h = g[5] - zb, dz = z - zb, s = (u + 1) / 2)
    ra + (rb - ra) * s
       + flare(dz, h, g[7], g[8])
       + g[10] * pleat(s, g[12]) * pow(max(0, dz) / h, 2);
function r_wall(u, z, g) = petal_t / cos(lean(z - g[4], g[5] - g[4], g[7], g[8]));
function r_web(u, z, g) =
    g[11] <= 0 ? r_in(u, z, g)
               : min(r_in(u, z, g), core_r - 1 + max(0, z - g[11]) * tan(web_slope));

// One petal.
module petal(g) {
    th0 = g[0];
    span = g[1];
    zb = g[4];
    pt = function (i, j, outer)
        let(u = -1 + 2*i/n_u, th = th0 + span * (u + 1)/2,
            z = zb + (lip(u, g[5], g[6], g[9]) - zb) * j / n_v,
            ri = r_in(u, z, g),
            r = outer ? ri + r_wall(u, z, g) : r_web(u, z, g))
        [r * cos(th), r * sin(th), z];
    m = (n_u + 1) * (n_v + 1);
    function id(i, j, o) = (o ? m : 0) + i * (n_v + 1) + j;
    function quad(a, b, c, d) = [[a, b, c], [a, c, d]];
    pts = [for (o = [0, 1], i = [0 : n_u], j = [0 : n_v]) pt(i, j, o == 1)];
    faces = [
        each [for (i = [0 : n_u - 1], j = [0 : n_v - 1])       // inner face
            each quad(id(i, j, 0), id(i + 1, j, 0), id(i + 1, j + 1, 0), id(i, j + 1, 0))],
        each [for (i = [0 : n_u - 1], j = [0 : n_v - 1])       // outer face
            each quad(id(i, j, 1), id(i, j + 1, 1), id(i + 1, j + 1, 1), id(i + 1, j, 1))],
        each [for (i = [0 : n_u - 1])                          // the foot
            each quad(id(i, 0, 0), id(i, 0, 1), id(i + 1, 0, 1), id(i + 1, 0, 0))],
        each [for (i = [0 : n_u - 1])                          // the lip
            each quad(id(i, n_v, 0), id(i + 1, n_v, 0), id(i + 1, n_v, 1), id(i, n_v, 1))],
        each [for (j = [0 : n_v - 1])                          // the two edges
            each quad(id(0, j, 0), id(0, j + 1, 0), id(0, j + 1, 1), id(0, j, 1))],
        each [for (j = [0 : n_v - 1])
            each quad(id(n_u, j, 0), id(n_u, j, 1), id(n_u, j + 1, 1), id(n_u, j + 1, 0))],
    ];
    polyhedron(pts, faces);
}

// The core, a solid of revolution: straight side, then a dome to the crown.
module core() rotate_extrude($fn = 96)
    polygon(concat([[0, 0], [core_r, 0]],
                   [for (a = [0 : 5 : 90]) let(s = cos(a))
                       [core_r * s, core_side + (core_top - core_side) * sin(a)]]));

// ------------------------------------------------------------------- checks
// The steepest lean any outer face reaches: the flare's slope plus the
// pleat's, which is steepest at the lip, where it is 2 * pleat / height.
function steepest(g) = atan(tan(max(abs(g[7]), abs(g[8]))) + 2 * g[10] / (g[5] - g[4]));
for (g = recs)
    assert(steepest(g) <= flare_max, str("a petal leans out past ", flare_max, " degrees: ", g));
// The outer ring stands on the bed and is webbed solid to the core's whole
// side: a petal peeling slowly off a vertical wall leaves a slit too narrow
// to print, a dome falling away from it opens a groove.
let(g = rings[len(rings) - 1])
    assert(g[4] == 0 && g[12] >= core_side, "the outer ring is not webbed up the core's side");
// Within a ring, where two neighbours overlap they are fused, not grazing:
// the step across the overlap leaves them sharing `ring_fuse` of wall.
for (g = rings)
    assert(petal_t - (g[3] - g[2]) * (360 / g[0]) / g[1] >= ring_fuse,
           str("two petals of a ring graze instead of fusing: ", g));
// Between rings, one ring's walls never reach into the next one's.
for (k = [0 : len(rings) - 2]) let(g = rings[k], h = rings[k + 1])
    assert(h[2] - h[11] - (g[3] + petal_t + g[11]) >= ring_gap - 1e-9,
           str("rings ", k, " and ", k + 1, " are closer than ", ring_gap));
// Every other ring must grow out of the core, its foot buried in it.
for (k = [0 : len(rings) - 2]) let(g = rings[k])
    assert(g[4] > 0 && g[4] < core_side && g[3] + petal_t < core_r - 0.3,
           str("ring ", k, "'s foot is not buried in the core"));
// The holes' roof and wall must fit under the core.
assert(core_side >= hp_apex + hp_wall + 0.2 - 1e-9, "the core is too low to roof the holes");

reach = max([for (g = recs) g[3] + flare(g[5] - g[4], g[5] - g[4], g[7], g[8])
                            + petal_t / cos(g[8])]);
echo(str("rose: ", 2 * reach, " mm across, ", max([for (g = recs) g[5] + g[9]]), " tall, ",
         len(recs), " petals"));

// ----------------------------------------------------------------- geometry
module rose() {
    core();
    for (g = recs) petal(g);
}

module rose_charm() difference() {
    rose();
    charm_h_holes();
}

rose_charm();
