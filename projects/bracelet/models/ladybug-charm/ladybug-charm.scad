// ladybug-charm — a two-colour ladybug, and a charm for the H-PIN mount.
//
// It snaps onto the upper half of an H-shaped pin (models/pin) whose lower
// half is already snapped into a pocket in a bracelet bar — exactly like the
// butterfly, with the same two holes (`charm_h_holes` in the lib).
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
//   * the two holes open on the bed and are gabled at 45 degrees (the lib).
//
// THE LADYBUG LIES ACROSS THE BAND, head at +y. The H is 11 mm across, so the
// shell has to be ~16 mm long that way just to hold its two holes.
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

include <../../lib/charm-pin.scad>

accent       = false;
base_color   = "red";       // preview tint only — the slicer picks filaments
accent_color = "black";

// ------------------------------------------------------------------ the shell
// A superellipsoid dome: an ellipse in plan, and in section a profile that
// stays full for longer than a sphere does before it rounds over — it has to
// stand a wall over the holes' gables near both ends.
sh_a     = 6.3;             // half-width, along the band
sh_b     = 8.0;             // half-length, across the band
sh_h     = 7.8;             // height
sh_p     = 3.3;             // profile exponent: 2 = ellipsoid, more = fuller

x0       = 5.0;             // the flat bottom stops here each side
relief   = 1.05;            // and the underside rises this much per mm beyond:
                            //   43.6 deg from vertical, as on the butterfly

// ------------------------------------------------------------------- the head
hd_a     = 3.2;             // half-width
hd_b     = 2.9;             // half-length
hd_h     = 5.0;             // height
hd_p     = 2.5;
hd_y     = 7.4;             // its centre — it tucks under the shell's front

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
legs     = [[-3.5, -30, 5.0], [0, 0, 5.8], [3.5, 30, 5.0]];   // [y, angle, length]
                            //   the middle pair longer: the shell is widest
                            //   there and hides more of them. 5.8 shows 4.0 mm
                            //   of leg, the same as the front and back pairs

// ----------------------------------------------------------------- the spots
// Hearts, pointing to the tail, and the seam between the wing cases. They are
// the accent colour to `skin` deep, measured into the shell.
skin     = 0.8;             // four layers
hearts   = [                // [x, y, size, tilt]
    [2.3,  4.0, 1.7,  15],
    [3.4,  0.2, 2.3,  20],
    [2.4, -4.4, 1.8, -10],
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
// The shell has to roof the holes by a wall at their ends, where the gables'
// ridges (`hp_apex`) meet the holes' outer walls (`hp_c_out`).
assert(shell_z(0, hp_c_out) >= hp_apex + hp_wall + 0.2,
       str("the shell stands only ", shell_z(0, hp_c_out), " over the gables' ends"));
assert(shell_z(0, hp_c_out + hp_wall) >= hp_roof,
       "the shell does not cover the holes' outer walls");
assert(sh_b >= hp_c_out + hp_wall + 0.5, "the holes run out of the shell's ends");

echo(str("ladybug: ", span, " mm along the band, shell ", 2*sh_a, " x ", 2*sh_b,
         " x ", sh_h, "; ", shell_z(0, hp_c_out), " mm over the gables' ends",
         " (need ", hp_apex + hp_wall, ")"));

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

module ladybug_charm() difference() { solid(); charm_h_holes(); }

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
