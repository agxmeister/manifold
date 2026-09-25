// heart-charm — a puffy 3D heart, and a charm for the H-PIN mount.
//
// It snaps onto the upper half of an H-shaped pin (models/pin) whose lower
// half is already snapped into a pocket in a bracelet bar — exactly like the
// butterfly and the ladybug, with the same two holes (`charm_h_holes` in the
// lib).
//
// A PILLOW HEART: one smooth surface, no seams. The outline is a smooth
// heart curve — two wide lobes, a soft notch, full rounded sides and a point
// rounded just enough not to be a knife — and the heart is that outline
// INFLATED: every ring of the surface is the outline scaled toward the
// middle, raised on one pillow profile. The notch's dip carries up the
// surface as a soft valley between the lobes. On the upper-left lobe, a
// cartoon SHINE — an arc and a dot — is sunk a little into the surface.
//
// WHY NOT DOMES. The first heart was the hull of a few domes. A hull is
// ruled between its domes, and wherever two of them take over from each other
// it leaves a visible edge: the sides had corners. This surface is one
// function of the outline, so it is as smooth as the outline is.
//
// IT TURNS. `angle` spins the heart in plan about the pin, anticlockwise seen
// from above; the holes stay put, because the pin runs across the band. At
// 0 the heart stands upright across the band, lobes at +y, point at -y. The
// heart is symmetric, so -a is the mirror image of a (all but the shine), and
// a + 180 is the heart upside down.
//
// THE HEART IS SIZED FOR EVERY ANGLE AT ONCE. The two holes and their walls
// are a 5.5 x 14 mm lozenge, and it must stay buried under a full wall at
// whatever angle the heart is turned to. An inflated surface falls away from
// the middle, so that takes a wide heart with a full profile (`prof_p`) and a
// shallow notch. The proof is the envelope test in CLAUDE.md, at every angle.
//
// IT PRINTS SEAT DOWN, exactly as modelled. Nothing needs support: every ring
// of the surface lies inside the ring below it (the outline is star-shaped
// about the middle, asserted), so the surface is a height field and faces
// only up. The shine is a groove cut down into the top — all floor. The holes
// open on the bed and are gabled at 45 degrees (the lib).
//
// THE BOTTOM IS FLAT TO THE EDGE, like the ladybug's legs, not relieved beyond
// |x| = 5 like the butterfly. The heart reaches ~12 mm along the band at
// some angles, and a 43.6-degree relief would cut its point away from below.
// So it rests on the neighbouring bars: the wearing direction is free, and the
// two joints beside it do not bend backwards past flat — the trade the
// ladybug already makes.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

angle    = 0;               // the heart's turn in plan, degrees anticlockwise

// ------------------------------------------------------------------ the heart
// The outline, in the heart's own frame: the classic heart curve
//   x = sin(t)^3,  y = 13 cos t - 5 cos 2t - 2 cos 3t - cos 4t,
// with three changes, each one number:
width    = 23;              // across the lobes
length   = 19;              // lobes' top to point — wider than long
side_q   = 1.6;             // x = sin^q, not sin^3: fuller, rounder sides
round_e  = 0.15;            // rounds the point and the notch's bottom: x runs
                            //   out linearly there instead of as a cube
notch_up = 5;               // lifts the top of the heart, the notch most: 1.5 mm
                            //   deep, against 4.6 unlifted, which the holes
                            //   cannot live under. A narrow lift raised a bump
                            //   in the notch instead; this one is cos(t)^6, as
                            //   broad as the lobes, so the top stays two curves
height   = 8.0;             // the pillow's crown
prof_p   = 4.0;             // its profile: 2 = elliptical, more = fuller
                            //   shoulders before it rounds down to the bed
n_t      = 240;             // stations round the outline
d_phi    = 3;               // and the profile's step, degrees

// the SHINE: an arc following the upper-left lobe's contour, and a dot. Both
// are placed in the surface's own coordinates — `s` the fraction of the way
// out from the middle, `t` the angle along the outline — so the arc runs
// parallel to the lobe's edge.
shine_s     = 0.66;         // how far out, as a fraction of the outline
shine_t     = [300, 334];   // the arc's run in t, degrees (270..360 = upper left)
shine_w     = 0.8;          // its width at the surface
shine_dot   = [0.66, 278, 0.9];   // the dot: s, t and diameter — off the arc by a wall
shine_deep  = 0.6;          // how far both sink into the surface — three layers
shine_flare = 20;           // the walls' lean outward, from vertical: a
                            //   vertical wall meets a sloping surface in a
                            //   knife-edged lip on its downhill side
shine_slope = 32;           // the steepest the surface may be under the shine

// ----------------------------------------------------------------- the curve
function raw_x(t) = let(s = sin(t))
    s * pow(s*s + round_e, (side_q - 1)/2) / pow(1 + round_e, (side_q - 1)/2);
function raw_y(t) = 13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)
    + notch_up * pow(max(0, cos(t)), 6);

ts       = [for (j = [0 : n_t - 1]) j * 360 / n_t];
raw_ys   = [for (t = ts) raw_y(t)];
y_mid    = (max(raw_ys) + min(raw_ys)) / 2;
y_span   = max(raw_ys) - min(raw_ys);

// A point of the outline, and of the surface: `s` = 1 is the outline itself.
function edge(t) = [raw_x(t) * width/2, (raw_y(t) - y_mid) * length / y_span];
function prof_s(phi) = pow(cos(phi), 2/prof_p);
function prof_z(phi) = height * pow(sin(phi), 2/prof_p);
function surf_z(s) = height * pow(max(0, 1 - pow(s, prof_p)), 1/prof_p);
function surf(s, t) = let(e = edge(t)) [s*e[0], s*e[1], surf_z(s)];

// ------------------------------------------------------------------- checks
// Star-shaped about the middle, or the rings would cross and the surface fold.
function bearing(t) = let(e = edge(t)) atan2(e[1], e[0]);
turns = [for (j = [0 : n_t - 1])
         let(d = bearing(ts[(j + 1) % n_t]) - bearing(ts[j]))
         d > 180 ? d - 360 : d < -180 ? d + 360 : d];
assert(max(turns) < 0 || min(turns) > 0,
       "the outline is not star-shaped about the middle — the surface would fold");
notch_y  = edge(0)[1];
tip_y    = edge(180)[1];
assert(notch_y >= hp_c_out + hp_wall + 0.3,
       str("the heart's notch at ", notch_y, " comes down onto the holes' walls"));

// The surface's slope, radially, at (s, t).
function slope(s, t) = let(d = 0.005, r = norm(edge(t)))
    atan((surf_z(s - d) - surf_z(s + d)) / (2*d*r));
function shine_edge_s(s, t, w) = s + w/2 / norm(edge(t));
assert(max(concat([for (t = [shine_t[0] : 2 : shine_t[1]]) slope(shine_edge_s(shine_s, t, shine_w), t)],
                  [slope(shine_edge_s(shine_dot[0], shine_dot[1], shine_dot[2]), shine_dot[1])]))
       <= shine_slope, "the shine sits on too steep a slope — move it inward");
// the land between the dot and the arc, measured to the arc's nearer end
shine_gap = min([for (t = shine_t) norm(surf(shine_dot[0], shine_dot[1]) - surf(shine_s, t))])
          - (shine_w + shine_dot[2])/2;
assert(shine_gap >= hp_wall, str("only ", shine_gap, " mm between the shine's arc and its dot"));
assert(shine_flare + (90 - shine_slope) >= 75,
       "the shine's downhill lip comes out sharper than 75 degrees");

echo(str("heart: ", width, " x ", length, " x ", height, " mm, turned ", angle,
         " deg; notch at ", notch_y, ", point at ", tip_y));

// ----------------------------------------------------------------- geometry
// The inflated heart: rings of the outline scaled by `prof_s`, raised by
// `prof_z`, from the bed (phi = 0) to a single crown point (phi = 90).
// `dz` lifts the whole surface; the shine's skin is cut between two of them.
phis = [for (p = [0 : d_phi : 90 - d_phi]) p];
module heart(dz = 0) {
    nr  = len(phis);
    pts = concat(
        [for (p = phis, t = ts) let(e = edge(t)) [prof_s(p)*e[0], prof_s(p)*e[1], prof_z(p) + dz]],
        [[0, 0, height + dz]]);
    top = nr * n_t;
    polyhedron(pts, concat(
        [[for (j = [n_t - 1 : -1 : 0]) j]],                           // the bed
        [for (i = [0 : nr - 2], j = [0 : n_t - 1])
            let(a = i*n_t + j, b = i*n_t + (j + 1) % n_t)
            [a, b, b + n_t, a + n_t]],                                  // the rings
        [for (j = [0 : n_t - 1])
            [(nr - 1)*n_t + j, (nr - 1)*n_t + (j + 1) % n_t, top]]      // the crown
    ));
}

// The shine. Each station along the arc is a cone opening upward at
// `shine_flare`, `shine_w` across where it meets the surface; consecutive
// stations are hulled.
module shine_cone(s, t, d) let(q = surf(s, t), k = d/2/tan(shine_flare), up = 2)
    translate([q[0], q[1], q[2] - k])
        cylinder(r1 = 0.001, r2 = d/2 + (k + up)*tan(shine_flare), h = k + up, $fn = 24);

module shine_raw() {
    for (t = [shine_t[0] : 2 : shine_t[1] - 2])
        hull() for (u = [t, t + 2]) shine_cone(shine_s, u, shine_w);
    shine_cone(shine_dot[0], shine_dot[1], shine_dot[2]);
}

// Kept to a skin `shine_deep` under the heart's own surface, so its floor
// follows the curve instead of coming to the cones' points.
module shine() intersection() {
    shine_raw();
    difference() {
        heart(0.5);
        translate([0, 0, -0.01]) heart(-shine_deep);
    }
}

module heart_charm() difference() {
    rotate(angle) difference() { heart(); shine(); }
    charm_h_holes();
}

heart_charm();
