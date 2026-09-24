// butterfly-charm — a 3D butterfly, and the charm that goes with the H-PIN mount.
//
// It snaps onto the upper half of an H-shaped pin (models/charm-h-pin) whose
// lower half is already snapped into a pocket in a bracelet bar.
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
//   * the two holes open on the bed, and their far ends are gabled at 45
//     degrees (see the lib).
//
// WHY A BUTTERFLY. The H is 11 mm across, so the charm needs a 5.5 x 14 mm
// lozenge of material around its legs. A butterfly's
// BODY is that lozenge. It runs ACROSS the band and the wings along it, so the
// wingspan is what `charm_reach` in bracelet.scad spaces.
//
// THE FLAT BOTTOM STAYS WITHIN |x| <= `x0`. The band's top is a plane only
// while it is still: turn a joint and the neighbour's knuckle ARM tilts up
// above it, just past the hinge gap's inner edge. Swept as a flat disc at the
// band's top, that reaches r = 5.8 from the bar's centre; this charm is long
// across the band, so its bottom is kept inside |x| = 5.0, the disc's reach at
// the knuckle clusters' edge, and relieved beyond. The swing test in CLAUDE.md is the proof: clear to 40
// degrees each way at wrist 130 and 180, binding at 60.
//
// The charm cannot swivel: two legs fix it square to the band.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ------------------------------------------------------------------ the body
body_top  = hp_apex + hp_wall + 0.1;   // 6.50 — roofs the holes by a wall.
                                 //   The +0.1 is for the ENDS, where the ridge
                                 //   rounds away over each gable's far end.
body_side = 3.9;                 // vertical sides up to here, then the round top.
                                 //   High enough that the top clears the holes'
                                 //   gables by a wall — asserted below.
body_pad  = 0.3;                 // the body's foot, this much proud of the least
                                 //   the holes need (`charm_h_boss_2d`)
ridge_r   = 1.9;                 // the rounded top: a capsule along the body
ridge_y   = hp_c_out + hp_wall + body_pad - ridge_r;   //   ... ending flush with the foot

head_r    = 1.9;                 // the head, a round-topped post at the front
head_y    = hp_c_out + hp_wall + 0.9;
head_h    = 4.6;                 // top of the head
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
spot_up   = [4.6, 3.6];      spot_up_d = 2.6;
spot_lo   = [3.95, -4.5];    spot_lo_d = 1.6;
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
body_x    = hp_boss_x/2 + body_pad;                         // 3.05
assert(spot_up[0] - spot_up_d/2 >= body_x + 0.1 && spot_lo[0] - spot_lo_d/2 >= body_x + 0.1,
       "a wing spot runs into the body");
assert(ant_lean <= 40, "the antennae lean past what prints without support");
// The body's round top has to clear each gable by a wall. The gable's slope and
// the hull's roof are both near 45 degrees, so check it where it is tightest:
// the gable's eave corner against the straight part of the side.
assert(body_side >= hp_roof + 0.2,
       "the body's vertical side stops below the holes' eaves");
assert(ridge_y + ridge_r <= hp_c_out + hp_wall + body_pad + 0.01,
       "the ridge overhangs the body's foot at its ends");

echo(str("3D butterfly: ", span, " mm wingspan; body ", body_top,
         " mm tall over two H-pin holes (gabled to ", hp_apex,
         "), wings ", wing_root, " thick at the root rising at ", wing_lift,
         " deg, tips ", tip_thick, " thick; flat bottom within |x| <= ", x0));

// ----------------------------------------------------------------- geometry
// A scaled unit circle takes its facet count from r = 1, not from the size it
// ends up — 21 sides on a 4.7 mm wing. Set it for the finished size instead.
module wing(c, r, tilt) translate(c) rotate(tilt) scale(r) circle(1, $fn = 96);

module wings_2d() for (m = [0, 1]) mirror([m, 0]) {
    wing(up_c, up_r, up_tilt);
    wing(lo_c, lo_r, lo_tilt);
}

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
    linear_extrude(body_side) offset(r = body_pad) charm_h_boss_2d();
    for (s = [-1, 1])
        translate([0, s*ridge_y, body_top - ridge_r]) sphere(r = ridge_r);
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
        charm_h_holes();
        spots();
    }
}

butterfly_charm();
