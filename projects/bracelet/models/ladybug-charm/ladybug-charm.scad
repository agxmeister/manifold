// ladybug-charm — a two-colour ladybug, a charm for the CONE PIN.
//
// It sits on a station bar with the bar's half-round rib in two of its
// eight grooves, and the cone pin, turned from under the band with the hex
// key, screws up into its threaded socket and clamps it down
// (lib/charm-cone.scad). The grooves are 45 degrees apart, so it can face
// any multiple of 45 degrees to the band.
//
// A round red SHELL with heart-shaped spots and a seam down its middle, a
// black HEAD at the front with two antennae, and three stubby LEGS each side.
// In two colours: the shell in the first, and the hearts, seam, head, legs and
// antennae in the second. The eyes and the antennae's tips go back to the
// first colour, so they show on the black head.
//
// IT PRINTS SEAT DOWN, exactly as modelled. Nothing needs support:
//
//   * the shell and the head are domes standing on the bed — every face
//     closes inward as it rises;
//   * past |x| = `x0` the shell's underside is relieved at 43.6 degrees
//     (as the butterfly's wings are);
//   * the legs lie FLAT ON THE BED, each a stadium in plan with a rounded
//     top — a dome drawn out, so every face closes inward as it rises;
//   * the antennae lean at `ant_lean`, inside the self-supporting cone;
//   * the socket and the grooves open on the bed; the socket's end is a
//     45-degree cone and the grooves' roofs 45-degree gables (the lib).
//
// THE SOCKET IS AT THE ORIGIN, under the shell's crown, head at +y. The
// shell stands `sh_h` = 8.8 there to roof the socket (`cn_need` = 8.75).
//
// THE SHELL IS ROUNDER THAN IT WAS ON THE H-PIN (15.2 wide, was 12.6), for
// the grooves. They reach 7.15 from the socket; at 12.6 the shell ended
// 0.2 past the diagonal grooves' ends, leaving a 0.2 curtain of shell
// between each end and the outside. At 15.2 that wall is ~0.8 even at the
// grooves' corners, and along the band, where the shell is narrowest, the
// grooves' far ends lie under the 43.6-degree relief, in the air.
//
// THE LEGS DODGE THE GROOVES. Where a leg is not fused to the shell above
// it, it lies flat on the bed only 1.6 tall — lower than a groove (1.63), so
// a groove crossing it there would cut it clean off. The along-the-band
// grooves run out under the relief, so no leg may leave the shell there:
// the legs leave at about +23, -23 and -56 degrees (the middle pair used to
// leave straight out along the band, right on those grooves). Asserted below.
//
// THE LEGS BREAK THE BUTTERFLY'S FLAT-BOTTOM RULE, on purpose. The user wants
// them lying flat, and there is no size limit on a charm. The shell keeps
// its bottom within |x| <= `x0` as the butterfly's does; the legs reach
// past it, flat on the band's top face, over the hinges either side. That
// costs nothing as the band curls round a wrist: the neighbours drop AWAY
// from the charm. Bent BACKWARDS, past flat, the neighbours rise into the
// legs sooner than they would into the butterfly — see CLAUDE.md for the
// measured angles.
//
// COLOUR. `accent = false` (the default) writes the charm as one solid, for
// the checks and a one-colour print. `accent = true` writes it as two
// top-level objects that together are exactly that solid; export with
// --enable=lazy-union and convert with tools/multicolor-3mf.py (see README).

$fa = 2;
$fs = 0.3;

include <../../lib/charm-cone.scad>

accent       = false;
base_color   = "red";       // preview tint only — the slicer picks filaments
accent_color = "black";

// ------------------------------------------------------------------ the shell
// A superellipsoid dome: an ellipse in plan, and in section a profile that
// stays full for longer than a sphere does before it rounds over — it has to
// stand a wall over the holes' gables near both ends.
sh_a     = 7.6;             // half-width — 6.3 on the H-pin; see the top
sh_b     = 9.1;             // half-length, head to tail
sh_h     = 8.8;             // height — 8.0 on the H-pin; the socket needs 8.75
sh_p     = 3.3;             // profile exponent: 2 = ellipsoid, more = fuller

x0       = 5.0;             // the flat bottom stops here each side
relief   = 1.05;            // and the underside rises this much per mm beyond:
                            //   43.6 deg from vertical, as on the butterfly

// ------------------------------------------------------------------- the head
hd_a     = 3.2;             // half-width
hd_b     = 2.9;             // half-length
hd_h     = 5.0;             // height
hd_p     = 2.5;
hd_y     = 8.5;             // its centre — it tucks under the shell's front

ant_d     = 1.3;            // the antennae: two leaning rods
ant_lean  = 35;             //   degrees from vertical — self-supporting
ant_len   = 3.0;
ant_splay = 55;             //   how far apart they fan, in plan
ant_x     = 0.9;            //   where they leave the head
ant_tip   = 0.9;            //   the last this-much of each is the body colour

eye_d     = 1.3;            // two body-colour eyes on the head's front
eye_x     = 1.1;
eye_z     = 2.6;

// ------------------------------------------------------------------- the legs
// Three a side, flat on the bed: a stadium `leg_w` wide with a rounded top
// `leg_h` high — the hull of two small domes. Each starts inside the shell,
// at `leg_x0`, and runs out at its angle in plan (0 = straight out along x).
leg_w    = 2.0;
leg_h    = 1.6;
leg_x0   = 3.5;
legs     = [[2.25, 10, 5.9], [-2.25, -10, 5.9], [-5.5, -50, 4.8]];   // [y, angle, length]
                            //   each leaves the shell clear of the grooves
                            //   (see the top) and shows ~2.8 mm of leg up to
                            //   its round end, as all three did before
leg_g    = 0.1;             // the least a leg keeps clear of a groove, where
                            //   it lies outside the shell

// ----------------------------------------------------------------- the spots
// Hearts, pointing to the tail, and the seam between the wing cases. They are
// the accent colour to `skin` deep, measured into the shell.
skin     = 0.8;             // four layers
hearts   = [                // [x, y, size, tilt] — x spread with the shell
    [2.8,  4.0, 1.7,  15],
    [4.1,  0.2, 2.3,  20],
    [2.9, -4.4, 1.8, -10],
];
seam_w   = 0.7;

// ------------------------------------------------------------------- checks
function sp_z(r, p) = pow(max(0, 1 - pow(r, p)), 1/p);       // unit profile
function shell_z(x, y) = sh_h * sp_z(sqrt(pow(x/sh_a, 2) + pow(y/sh_b, 2)), sh_p);
function rel_z(x) = max(0, (abs(x) - x0) * relief);

leg_a    = function(l) [leg_x0, l[0]];
leg_b    = function(l) leg_a(l) + l[2]*[cos(l[1]), sin(l[1])];
span     = 2*(max([for (l = legs) leg_b(l)[0]]) + leg_w/2);   // along the band

assert(leg_w >= 1.2 && leg_h >= 1.2, "a leg is thinner than a printable wall");
assert(ant_lean <= 40, "the antennae lean past what prints without support");
// The socket: `cn_roof` of shell over its coned end and over its rim, along
// the shell's narrow (x) axis, where the shell falls fastest.
sock_roof = min([for (i = [0 : 20]) let(r = i/20 * cn_hole_maj/2)
                 shell_z(r, 0) - (cn_bore + max(0, cn_hole_min/2 - r))]);
assert(sock_roof >= cn_roof, str("only ", sock_roof, " mm of shell over the socket"));
// The grooves: `cn_g_roof` of shell over each one's ridge, until the groove
// runs out through the shell's side. Along the band the shell ends at 6.3,
// before the grooves do (7.15); there the roof thins to nothing over the last
// few hundredths as the side drops to the bed, which is a clean exit, not a
// thin roof. Assert that run stays short.
function g_r(a, r) = [-sin(a), cos(a)] * r;              // along groove `a`
g_thin = max([for (a = [0 : cn_step : 359])
              len([for (i = [0 : 150]) let(p = g_r(a, cn_g_in + i/150*(cn_g_out - cn_g_in)),
                                          t = shell_z(p[0], p[1]) - cn_g_apex)
                   if (t > 0 && t < cn_g_roof) 1]) * (cn_g_out - cn_g_in)/150]);
assert(g_thin <= 0.1, str("a groove's roof is under ", cn_g_roof, " for ", g_thin, " mm"));
// Where a leg is not fused to the shell (too little shell over a groove, or
// the relief lifting the shell off the leg's top), no part of it may come
// within `leg_g` of a groove: it is lower than one.
function g_dist(p) = min([for (a = [0 : cn_step : 359])
    let(u = [-sin(a), cos(a)], v = [cos(a), sin(a)], s = p*u)
    s < cn_g_in || s > cn_g_out ? 99 : abs(p*v) - cn_g_r]);
leg_clear = min([for (l = legs, i = [0 : 60], k = [-1 : 0.5 : 1])
    let(d = leg_b(l) - leg_a(l), n = [-d[1], d[0]] / norm(d),
        p = leg_a(l) + i/60 * d + k * leg_w/2 * n)
    if (shell_z(p[0], p[1]) < cn_g_apex + cn_g_roof || rel_z(p[0]) > leg_h - 0.6) g_dist(p)]);
assert(leg_clear >= leg_g, str("a leg comes within ", leg_clear, " of a groove"));

echo(str("ladybug: ", span, " mm along the band, shell ", 2*sh_a, " x ", 2*sh_b,
         " x ", sh_h, "; ", sock_roof, " mm over the socket; groove roofs thin for ",
         g_thin, " mm; legs ", leg_clear, " clear of the grooves"));

// ----------------------------------------------------------------- geometry
// A superellipsoid dome on z = 0. The profile is swept by angle, not radius,
// so the facets stay even where it turns down to the bed. `scale` would take
// the facet count from r = 1, so it is set for the finished size.
module dome(a, b, h, p) scale([a, b, h])
    rotate_extrude($fn = 128)
        polygon(concat([[0, 0]],
            [for (t = [0 : 2 : 90]) [pow(cos(t), 2/p), pow(sin(t), 2/p)]]));

// Everything at or above the bed, and beyond `x0` at or above the relief.
module keep() for (m = [0, 1]) mirror([m, 0, 0])
    rotate([90, 0, 0]) linear_extrude(60, center = true)
        polygon([[-0.01, 0], [x0, 0], [12, (12 - x0)*relief], [12, 20], [-0.01, 20]]);

// The colour region is built from copies GROWN by `g`, so its surface never
// lies on the solid's own: coincident faces make slivers and a ragged seam
// between the two colours. The grown dome is lowered by `g` too, so its
// footprint at the bed still reaches past the real one.
module shell(g = 0) translate([0, 0, -g]) dome(sh_a + g, sh_b + g, sh_h + 2*g, sh_p);
module shell_inner() translate([0, 0, -0.01]) dome(sh_a - skin, sh_b - skin, sh_h - skin, sh_p);

module head(g = 0) translate([0, hd_y, -g]) dome(hd_a + g, hd_b + g, hd_h + 2*g, hd_p);
module head_inner() translate([0, hd_y, -0.01]) dome(hd_a - skin, hd_b - skin, hd_h - skin, hd_p);

function ant_base(s) = [s*ant_x, hd_y + 0.4, hd_h - 0.9];
module antennae(g = 0) for (s = [-1, 1])
    translate(ant_base(s)) rotate([0, 0, -s*ant_splay/2]) rotate([-ant_lean, 0, 0])
        hull() {
            sphere(d = ant_d + 2*g, $fn = 24);
            translate([0, 0, ant_len]) sphere(d = ant_d + 2*g, $fn = 24);
        }
// the tips: the same rod from `ant_tip` short of its end, a hair fatter
module antenna_tips() for (s = [-1, 1])
    translate(ant_base(s)) rotate([0, 0, -s*ant_splay/2]) rotate([-ant_lean, 0, 0])
        translate([0, 0, ant_len - ant_tip]) cylinder(d = ant_d + 1, h = ant_tip + 1);

module legs(g = 0) for (m = [0, 1], l = legs) mirror([m, 0, 0])
    hull() for (p = [leg_a(l), leg_b(l)])
        translate([p[0], p[1], -g]) dome(leg_w/2 + g, leg_w/2 + g, leg_h + 2*g, 2.5);

// A heart pointing down (-y), `s` across each lobe.
module heart(s) {
    rotate(45) square(s, center = true);
    for (k = [-1, 1]) translate([k*s/(2*sqrt(2)), s/(2*sqrt(2))]) circle(d = s, $fn = 48);
}

module spots_2d() {
    for (m = [0, 1], h = hearts) mirror([m, 0])
        translate([h[0], h[1]]) rotate(h[3]) heart(h[2]);
    translate([-seam_w/2, -sh_b - 1]) square([seam_w, sh_b + hd_y]);
}
// on the FRONT of the head, looking forward, clear of the antennae
module eyes() for (k = [-1, 1])
    translate([k*eye_x, hd_y, eye_z]) rotate([-90, 0, 0]) cylinder(d = eye_d, h = 2*hd_b, $fn = 48);

module solid() union() {
    intersection() { shell(); keep(); }
    head(); legs(); antennae();
}

module ladybug_charm() difference() { solid(); cn_charm_mount(); }

// The accent colour, as a region: the head, legs and antennae where they are
// outside the shell; the spots, `skin` deep into it; less the eyes and tips.
// The shell it is cut back to is shrunk by `cg`, so where the head and legs
// meet it the boundary runs just under its surface, not along it.
cg = 0.05;
module accent_region() difference() {
    union() {
        difference() {
            union() { head(0.2); legs(0.2); antennae(0.2); }
            // carried a millimetre under the bed, or its floor lies ON the
            // solid's and leaves zero-thickness sheets in the accent part
            scale([(sh_a - cg)/sh_a, (sh_b - cg)/sh_b, 1]) {
                shell();
                translate([0, 0, -1]) scale([sh_a, sh_b, 1]) cylinder(r = 1, h = 1.01, $fn = 128);
            }
        }
        intersection() {
            difference() { shell(0.2); shell_inner(); }
            translate([0, 0, -1]) linear_extrude(sh_h + 2) spots_2d();
        }
    }
    intersection() {
        difference() { head(0.2); head_inner(); }
        eyes();
    }
    antenna_tips();
}

if (accent) {
    color(base_color)   difference()   { ladybug_charm(); accent_region(); }
    color(accent_color) intersection() { ladybug_charm(); accent_region(); }
} else
    ladybug_charm();
