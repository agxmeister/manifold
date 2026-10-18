// butterfly-charm — a 3D butterfly, a charm for the CONE PIN.
//
// It sits on a station bar with the bar's half-round rib in two of its
// eight grooves, and the cone pin, turned from under the band with the hex
// key, screws up into its threaded socket and clamps it down
// (lib/charm-cone.scad). The grooves are 45 degrees apart, so it can sit
// square to the band, along it, or at any multiple of 45 degrees.
//
// IT PRINTS SEAT DOWN — the face that lands on the bracelet is the face that
// lands on the bed — and that is what lets it be a solid thing instead of a
// flat plate. A raised BODY runs down the middle, rounded over the top, with a
// head at the front and two antennae; the WINGS lift away from it in a shallow
// V. Nothing needs support:
//
//   * the body's sides are vertical and its top closes inward;
//   * the wings' tops rise outward — a top surface — and their undersides are
//     relieved just inside 45 degrees outside `x0`, so every layer lands on
//     the one below;
//   * the antennae lean out at `ant_lean`, inside the self-supporting cone;
//   * the socket and the grooves open on the bed; the socket's blind end is
//     a 45-degree cone and each groove's roof a 45-degree gable (the lib).
//
// THE THORAX HOLDS THE SOCKET. The socket is an M5 thread 5.5 deep with a
// coned end, `cn_need` = 8.75 tall over the axis with its roof. The body
// stays as low as it was (6.85) at its ends; in the middle a round THORAX
// rises over the socket, and the hull of the two makes one smooth hump. The
// body runs ACROSS the band and the wings along it, so the wingspan is what
// `charm_reach` in bracelet.scad spaces (at the 0-degree position).
//
// THE FLAT BOTTOM STAYS WITHIN |x| <= `x0`. The band's top is a plane only
// while it is still: turn a joint and the neighbour's knuckle ARM tilts up
// above it, just past the hinge gap's inner edge. Swept as a flat disc at the
// band's top, that reaches r = 5.8 from the bar's centre; this charm is long
// across the band, so its bottom is kept inside |x| = 5.0, the disc's reach at
// the knuckle clusters' edge, and relieved beyond. The swing test in CLAUDE.md is the proof: clear to 40
// degrees each way at wrist 130 and 180, binding at 60. Measured with the
// butterfly square to the band; turned, its wings reach further along it.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-cone.scad>

// ------------------------------------------------------------------ the body
body_x    = 3.4;                 // the body's foot: half its width (along the band),
body_y    = 7.95;                //   half its length (across it),
body_cr   = 1.5;                 //   and its corners' radius. The H-pin's sizes,
                                 //   kept so the butterfly keeps its shape
body_top  = 6.85;                // the body's height at its ENDS
body_side = 3.9;                 // vertical sides up to here, then the round top
ridge_r   = 1.9;                 // the rounded top: a capsule along the body
ridge_y   = body_y - ridge_r;    //   ... ending flush with the foot

thx_wall  = 1.2;                 // the THORAX round the socket: this much wall
thx_r     = cn_hole_maj/2 + thx_wall;   // 3.85 — round the thread's crests,
thx_side  = cn_bore;             //   vertical as high as the thread runs,
thx_top   = 9.3;                 //   and domed (a half-ellipsoid) to here —
                                 //   the coned end + `cn_roof` need 8.75

head_r    = 1.9;                 // the head, a round-topped post at the front
head_y    = body_y + 0.6;
head_h    = 5.4;                 // top of the head: 4.6 under the 6.85 body,
                                 //   raised to stay in scale with the thorax
ant_d     = 1.3;                 // the antennae: two leaning rods
ant_lean  = 38;                  //   degrees from vertical — self-supporting
ant_len   = 3.0;
ant_splay = 35;                  //   how far apart they fan, in plan

// ----------------------------------------------------------------- the wings
up_c      = [4.3, 3.1];      // upper wing: centre,
up_r      = [3.6, 4.7];      //   semi-axes,
up_tilt   = -22;             //   and lean — its top swings OUT
lo_c      = [3.2, -3.9];     // lower wing, smaller, leaning the other way
lo_r      = [2.7, 3.6];
lo_tilt   = 28;

x0        = 5.0;             // the flat bottom stops here each side (see above)
relief    = 1.05;            // and the underside rises this much per mm beyond it:
                             //   43.6 deg from vertical. Not 45 exactly — faces
                             //   ON the threshold flicker in and out of it and
                             //   the overhang check splits one clean ramp into
                             //   a "ramp" and a phantom "bridge".
wing_root = 2.2;             // the wing's thickness where it meets the body
wing_lift = 15;              // and the V: its top rises outward at this angle

// Spots, cut into the wings' tops. A cone opening upward is all floor, so it
// prints on a top face with nothing overhanging.
spot_up   = [5.25, 3.6];     spot_up_d = 2.6;   // both moved out to clear the
spot_lo   = [4.65, -4.5];    spot_lo_d = 1.4;   //   thorax (2026-10-18)
spot_deep = 0.7;

// ------------------------------------------------------------------- checks
span      = 2*max(up_c[0] + up_r[0], lo_c[0] + lo_r[0]);   // along the band
wing_top  = function(x) wing_root + abs(x) * tan(wing_lift);
wing_bot  = function(x) max(0, (abs(x) - x0) * relief);
tip_thick = wing_top(span/2) - wing_bot(span/2);

assert(span <= 16.2,
       str("the wings span ", span, " — that outgrows `charm_reach` in bracelet.scad"));
assert(tip_thick >= 1.2,
       str("the wing tips come out ", tip_thick, " mm thick — raise wing_root or wing_lift"));
// The body's outline never reaches past max(body_x, thx_r): hull of the two.
body_reach = max(body_x, thx_r);
assert(spot_up[0] - spot_up_d/2 >= body_reach + 0.1 && spot_lo[0] - spot_lo_d/2 >= body_reach + 0.1,
       "a wing spot runs into the body");
assert(ant_lean <= 40, "the antennae lean past what prints without support");
assert(ridge_y > 0, "the ridge is longer than the body");
// The socket, under the thorax's dome: `cn_roof` over the coned end's apex,
// and over the thread's top corner (r = cn_hole_maj/2 at cn_bore), measured
// straight up — the dome is a half-ellipsoid.
thx_z     = function(r) thx_side + (thx_top - thx_side) * sqrt(max(0, 1 - pow(r/thx_r, 2)));
assert(thx_top - cn_apex >= cn_roof,
       str("only ", thx_top - cn_apex, " mm of thorax over the socket's apex"));
assert(thx_z(cn_hole_maj/2) - cn_bore >= cn_roof + 0.5,
       "the thorax's dome comes down too close to the thread's top");
// The grooves: across the body (|x|) they run under the wings, whose root is
// the thinnest place a groove's ridge passes under.
assert(wing_root - cn_g_apex >= 0.5 && wing_top(cn_g_in) - cn_g_apex >= cn_g_roof,
       str("only ", wing_top(cn_g_in) - cn_g_apex, " mm of wing over a groove"));
assert(body_side - cn_g_apex >= cn_g_roof, "the body is too low over the grooves");

echo(str("3D butterfly: ", span, " mm wingspan; body ", body_top,
         " mm tall at its ends, thorax ", thx_top, " over the cone pin's socket",
         " (", thx_top - cn_apex, " over its apex), wings ", wing_root,
         " thick at the root rising at ", wing_lift,
         " deg, tips ", tip_thick, " thick; flat bottom within |x| <= ", x0));

// ----------------------------------------------------------------- geometry
// A scaled unit circle takes its facet count from r = 1, not from the size it
// ends up — 21 sides on a 4.7 mm wing. Set it for the finished size instead.
module wing(c, r, tilt) translate(c) rotate(tilt) scale(r) circle(1, $fn = 96);

// The notch between the fore- and hindwing has its apex at (4.5, -1.3),
// just beside the groove that runs along the band (|y| <= `cn_g_r`), and the
// forewing's lower edge then runs at a shallow angle across that groove's
// wall: a knife sliver. So the notch is filled down to `notch_y`, a full
// wall below the groove — the forewing gets a straight lower edge there —
// and the corners this makes are rounded by `notch_round`. The notch below
// that line, between the wings, is kept.
notch_y     = -(cn_g_r + 1.0);       // -2.15
notch_round = 0.6;

module wing_side_2d() {
    wing(up_c, up_r, up_tilt);
    wing(lo_c, lo_r, lo_tilt);
    intersection() {
        hull() { wing(up_c, up_r, up_tilt); wing(lo_c, lo_r, lo_tilt); }
        translate([0, notch_y]) square([20, 20]);
    }
}

module wings_2d() for (m = [0, 1]) mirror([m, 0])
    offset(r = notch_round) offset(r = -notch_round)        // convex corners
        offset(r = -notch_round) offset(r = notch_round)    // concave corners
            wing_side_2d();

// The wings as solids: the outline, cut to the V. For each side, a prism
// whose section (in x-z) is the V's top above and the 45-degree relief below.
module wing_v() for (m = [0, 1]) mirror([m, 0, 0])
    rotate([90, 0, 0]) linear_extrude(40, center = true)
        polygon([[-0.01, 0], [x0, 0], [9, (9 - x0) * relief],
                 [9, wing_top(9)], [-0.01, wing_root]]);

module wings() intersection() {
    linear_extrude(10) wings_2d();
    wing_v();
}

module body() hull() {
    linear_extrude(body_side) offset(r = body_cr)
        square([2*(body_x - body_cr), 2*(body_y - body_cr)], center = true);
    for (s = [-1, 1])
        translate([0, s*ridge_y, body_top - ridge_r]) sphere(r = ridge_r);
    // the thorax: a round post up the thread, domed over the socket
    cylinder(r = thx_r, h = thx_side, $fn = 96);
    translate([0, 0, thx_side])
        scale([thx_r, thx_r, thx_top - thx_side]) sphere(1, $fn = 96);
}

module head() hull() {
    translate([0, head_y, 0]) cylinder(r = head_r, h = 0.01);
    translate([0, head_y, head_h - head_r]) sphere(r = head_r);
}

module antennae() for (s = [-1, 1])
    translate([0, head_y, head_h - head_r])
        rotate([0, 0, -s*ant_splay/2]) rotate([-ant_lean, 0, 0])
            hull() {
                sphere(d = ant_d);
                translate([0, 0, head_r - 0.3 + ant_len]) sphere(d = ant_d);
            }

module spots() for (s = [-1, 1], p = [[spot_up, spot_up_d], [spot_lo, spot_lo_d]]) {
    x = s*p[0][0];  y = p[0][1];  d = p[1];
    tip = d - 2*spot_deep;
    // the cone, then straight up out of the tilted surface — a cone carried on
    // above the surface keeps widening and bites into the body beside it
    translate([x, y, wing_top(x) - spot_deep]) {
        cylinder(d1 = tip, d2 = d, h = spot_deep);
        translate([0, 0, spot_deep - 0.01]) cylinder(d = d, h = 2);
    }
}

module butterfly_charm() {
    difference() {
        union() {
            wings();
            body();
            head();
            antennae();
        }
        cn_charm_mount();
        spots();
    }
}

butterfly_charm();
