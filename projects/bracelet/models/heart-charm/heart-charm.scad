// heart-charm — a puffy 3D heart, a charm for the CONE PIN.
//
// It sits on a station bar with the bar's rib in two of its grooves, and the
// cone pin, turned from under the band, screws up into its threaded socket
// and clamps it down (lib/charm-cone.scad). Eight grooves, so it can sit at
// any multiple of 45 degrees to the band.
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
// THE ANGLE IS CHOSEN ON THE WRIST, not in the model: the grooves let it sit
// at any multiple of 45 degrees. (It used to be an `angle` parameter, one
// export per angle, when the H-pin's holes fixed it.) Lobes at +y, point at
// -y, the socket at the origin.
//
// IT PRINTS SEAT DOWN, exactly as modelled. Nothing needs support: every ring
// of the surface lies inside the ring below it (the outline is star-shaped
// about the middle, asserted), so the surface is a height field and faces
// only up. The shine is a groove cut down into the top — all floor. The
// socket and the grooves open on the bed; their roofs are 45-degree cones and
// gables (the lib).
//
// THE BOTTOM IS FLAT TO THE EDGE. The heart reaches ~12 mm along the band at
// some angles, and a relief would cut its point away from below.
// So it rests on the neighbouring bars: the wearing direction is free, and the
// two joints beside it do not bend backwards past flat — the trade the
// ladybug already makes.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-cone.scad>

// ------------------------------------------------------------------ the heart
// The outline, in the heart's own frame: the classic heart curve
//   x = sin(t)^3,  y = 13 cos t - 5 cos 2t - 2 cos 3t - cos 4t,
// with three changes, each one number:
width    = 23;              // across the lobes
length   = 19.4;            // lobes' top to point — wider than long
side_q   = 1.6;             // x = sin^q, not sin^3: fuller, rounder sides
round_e  = 0.15;            // rounds the point and the notch's bottom: x runs
                            //   out linearly there instead of as a cube
notch_up = 5;               // lifts the top of the heart, the notch most: 1.5 mm
                            //   deep, against 4.6 unlifted. A narrow lift raised a bump
                            //   in the notch instead; this one is cos(t)^6, as
                            //   broad as the lobes, so the top stays two curves
height   = 9.2;             // the pillow's crown. The socket stands `cn_need`
                            //   = 8.75 tall over the axis (thread, its coned
                            //   end, roof); 8.0 on the H-pin
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
assert(shine_gap >= 1.2, str("only ", shine_gap, " mm between the shine's arc and its dot"));
assert(shine_flare + (90 - shine_slope) >= 75,
       "the shine's downhill lip comes out sharper than 75 degrees");

// The socket's roof must stay under the heart with `cn_roof` over it: check
// the surface over the bore's edge too, where the coned end is lowest but
// the surface has fallen furthest.
roof_min = min([for (t = ts) let(r = norm(edge(t)))
                       surf_z(cn_hole_maj/2 / r) - cn_bore]);
assert(height - cn_apex >= cn_roof,
       str("only ", height - cn_apex, " mm of heart over the socket's roof"));
assert(roof_min >= cn_roof,
       str("only ", roof_min, " mm of heart over the chamber's rim"));
// ... and over every groove's ridge, out to its far end, whichever way it
// runs (the outline is star-shaped, so its radius along a groove is the
// outline's at that bearing).
function edge_r(b) = let(i = [for (j = [0 : n_t - 1]) let(d = abs(bearing(ts[j]) - b))
                                  min(d, 360 - d)])
                     norm(edge(ts[search(min(i), i)[0]]));
g_roof_min = min([for (a = [0 : cn_step : 359]) let(b = 90 + a)
                  surf_z(cn_g_out / edge_r(b > 180 ? b - 360 : b)) - cn_g_apex]);
assert(g_roof_min >= cn_g_roof,
       str("only ", g_roof_min, " mm of heart over a groove's far end"));

echo(str("heart: ", width, " x ", length, " x ", height, " mm; notch at ",
         notch_y, ", point at ", tip_y, "; ", g_roof_min,
         " over the grooves' far ends"));

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
    heart();
    shine();
    cn_charm_mount();
}

heart_charm();
