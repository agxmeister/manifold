// charm-cone — a second way to hang a charm on the bracelet: the CONE PIN.
// It sits ALONGSIDE the dovetail H-pin (lib/charm-dovetail.scad) until it has
// been proven on a print; `mount = "cone"` in bracelet.scad and in a charm
// picks it.
//
// A pin with a CONE at its foot and an M5 THREAD on top. It goes into a
// station bar FROM UNDERNEATH: the cone seats in a countersink in the bar's
// underside, flush with it, and the thread stands up out of the bar's top.
// The charm screws down onto the thread until it clamps the bar between
// itself and the cone. The bar has no thread at all.
//
// THE CONE IS ROUND, so a charm can be screwed down facing any way; it holds
// by the clamp. A charm can be turned on the bracelet by loosening it, turning
// it and tightening it again.
//
// What the first print (2026-10-04) taught, all at the user's request:
//   * the BALL at the thread's tip and the CLICK fingers round it added no
//     hold worth having — gone; the thread is longer instead (1.26 -> 2 turns);
//   * the 15-degree RIDGES on the bar did not print at all, too small — gone,
//     with the charm's ring of grooves;
//   * the SLOT that split the cone into a spring is not needed — the cone is
//     a TRUE cone, with only the flat it prints on;
//   * the pin was too thin — M3 -> M5, the cone 4.5 -> 6.7.
//
// WHERE THE ROOM FOR A FAT PIN COMES FROM. A bar is only 6.0 along the band.
// On its +x side, between its two knuckle clusters, is a gap the hinge does
// not use, and the knuckles either side of it are the bar's OWN fork lugs. So
// a station bar fills that gap completely — one wide lug with the lugs' own
// knuckle profile, out to their ends (bracelet.scad, `charm_seat`) — and the
// pin moves `cn_off` towards it. The fill swings inside the lugs' envelope,
// so the band bends exactly as before. (The -x gap is flanked by the
// NEIGHBOUR's lugs, which swing past it, so it stays open.)

// THE PIN PRINTS LYING DOWN, on a flat along its whole length, like the old
// M4 screw (e1425c5, printed and confirmed). The CHARM prints seat-down: the
// thread's mouth on the bed, the bore's blind end a 45-degree cone.
//
// This file draws nothing — variables, functions and modules only. Everything
// is named `cn_*`.
//
// FRAME: the PIN'S AXIS is x = y = 0, z = 0 the bar's top face, which is the
// charm's seat. The bar runs down to z = -`cn_bar`. In the band the axis sits
// `cn_off` towards +x of the station bar's centre — bracelet.scad moves it.
//
//          charm   __/\__  <- the bore's coned end
//                 | |  | |
//                 | |  | |  <- thread
//      bar top ===|_|  |_|=====|  z = 0
//                   |  |       |  <- boss, into the +x gap
//                   |  |       |
//      bar bottom _/    \______|  z = -cn_bar, the cone flush with it

// ------------------------------------------------------------ the thread
// The tooth of the M4 screw (e1425c5), printed and confirmed on a charm that
// printed seat-down: depth, pitch, crest, flanks and fit all kept, at M5.
cn_maj    = 5.0;    // male major diameter
cn_depth  = 0.4;    // radial depth of the thread
cn_pitch  = 2.30;   // lead per turn — coarse, for a 0.4 mm nozzle
cn_crest  = 0.45;   // axial width of the crest flat
cn_lo     = 0.30;   // the male's -z flank (axial run)
cn_hi     = 0.50;   // the male's +z flank
cn_fit    = 0.15;   // clearance, radial AND axial — the proven `scr_fit`
cn_hi_f   = 0.65;   // the female's +z flank. The charm prints seat-down, so
                    //   that flank is the groove's CEILING: kept slack, at the
                    //   proven 0.65, not grown from `cn_hi`
cn_tip    = 0.60;   // lead-in taper at the top of the male thread
cn_thread = 5.0;    // male thread above the bar's top: what a charm screws on
cn_lead   = 0.5;    // dead depth past the male's tip in the charm's bore, so
                    //   the charm clamps the bar before the thread bottoms out
cn_sink   = 0.5;    // the thread starts this far DOWN inside the bar, so the
                    //   smooth shaft's shoulder stays below the bar's top. Run
                    //   it to the top face exactly and a cone printed a hair
                    //   fat stands the shoulder proud: the charm tightens on
                    //   the pin instead of on the bar, and the joint rattles

cn_minor    = cn_maj - 2*cn_depth;          // 4.20
cn_hole_maj = cn_maj + 2*cn_fit;            // 5.30
cn_hole_min = cn_minor + 2*cn_fit;          // 4.50

// ---------------------------------------------------------------- the bar
cn_bar    = 4.2;    // the bar's thickness == the band's `thick`, asserted there
cn_hole   = cn_hole_maj;   // the bar's plain hole: the thread passes up it
cn_cs_r   = 3.35;   // the countersink's radius at the bar's underside
// The cone is LONG (the user's sketch, 2026-10-04): it runs the whole way
// from the pin's foot up to where the thread starts, so the pin has no
// straight shaft at all. Its half-angle from the axis is therefore SOLVED,
// ~12.9 degrees: the countersink is a steep, easy ceiling, and the pin bears
// on it over ~3 mm instead of ~1.
//   It costs two things, both small here. A steep wedge pushes the bar's walls
// apart ~4.4x the clamp's pull (a 35-degree cone: ~1.4x), so do not crank a
// charm down hard. And a cone printed `e` fat radially sits `e/tan(a)` ~ 4.4e
// higher: the 0.5 of `cn_sink` covers e up to ~0.11, past which the thread's
// start reaches the charm's seat.
cn_cs_a   = atan((cn_cs_r - cn_maj/2) / (cn_bar - cn_sink));
cn_off    = 1.10;   // the pin's axis, from the station bar's centre, towards
                    //   +x, where the gap beside the bar is filled
cn_wall   = 0.75;   // the least bar left round the countersink, at the bed
cn_boss_y = 2.6;    // the fill's half-width across the band: the gap between
                    //   the clusters (2.1 a side) and 0.5 into each of the
                    //   bar's own fork lugs, so it fuses with them

// ---------------------------------------------------------------- the pin
cn_shaft  = cn_maj; // the smooth shaft through the bar
cn_recess = 0.1;    // the pin's foot stops this far inside the bar's
                    //   underside, so nothing stands proud against the skin
cn_flat   = 1.75;   // axis to the flat it prints on. Two bounds: past
                    //   r*cos(45) of the thread's crest = 1.768 the shaft
                    //   leaves the bed past 45 degrees; under the core
                    //   (`cn_minor`/2 = 2.1) or the grooves' roots hang

// ------------------------------------------------------------ the charm
cn_roof   = 1.0;    // the least a charm may leave over its bore's apex

// --------------------------------------------------------------- derived
cn_cs_h   = (cn_cs_r - cn_hole/2) / tan(cn_cs_a);       // 3.05 — countersink
cn_base   = -cn_bar + cn_recess;                        // -4.10 — pin's foot
cn_base_r = cn_cs_r - cn_recess * tan(cn_cs_a);         // its radius there
cn_cone_top = -cn_bar + (cn_cs_r - cn_shaft/2) / tan(cn_cs_a);
cn_len    = cn_thread - cn_base;                        // overall
cn_bore   = cn_thread + cn_lead;                        // a charm's bore
cn_apex   = cn_bore + cn_hole_min/2;                    // its coned end, 45 deg
cn_need   = cn_apex + cn_roof;                          // a charm's least height
                                                        //   over the pin's axis

// The thread's numbers, from the M4's own asserts.
function cn_ceil_gen(r, f) = atan(r / sqrt(pow(cn_pitch/(2*PI), 2)
                                         + pow(f/cn_depth, 2) * r * r));
cn_ceiling = cn_ceil_gen(cn_hole_maj/2, cn_hi_f);
cn_crest_f = cn_pitch - ((cn_crest + 2*cn_fit) + cn_hi_f + (cn_lo + cn_fit));
cn_turns   = (cn_thread - cn_tip) / cn_pitch;
cn_ov_thr  = 90 - acos(cn_flat / (cn_maj/2));           // shaft leaves the bed
cn_ov_cone = 90 - acos(cn_flat / cn_base_r);            // cone leaves the bed
cn_seat    = cn_cs_r - cn_hole/2;                       // the cone's shoulder

assert(cn_ceiling <= 45,
       str("the charm's groove roof hangs at ", cn_ceiling, " deg from vertical"));
assert(cn_crest_f >= 0.4, str("the female thread's crest is only ", cn_crest_f));
assert(cn_turns >= 1.75, str("only ", cn_turns, " turns of thread in the charm"));
assert(cn_ov_thr <= 45,
       str("the thread leaves the bed at ", cn_ov_thr, " deg — lower cn_flat"));
assert(cn_ov_cone <= 45,
       str("the cone leaves the bed at ", cn_ov_cone, " deg — lower cn_flat"));
assert(cn_flat < cn_minor/2, "the flat misses the thread's core");
assert(cn_seat >= 0.6, str("the cone's shoulder is only ", cn_seat, " wide"));
assert(cn_cs_a <= 40, "the countersink's ceiling is too flat to print");
assert(cn_cs_h < cn_bar - 1.0, "the countersink runs up most of the bar");
assert(abs(cn_cone_top + cn_sink) < 1e-9, "the cone must run up to the thread");

// --------------------------------------------------------- thread modules
// One period of the MALE tooth in (radius, axial), swept along a helix — the
// six-point profile of the M4 screw: the inner tongues are horizontal, so the
// flank angle drawn is the one exported, and the rib merges with the core.
cn_tooth = [
    [cn_minor/2 - 0.3, -(cn_crest/2 + cn_lo)],
    [cn_minor/2,       -(cn_crest/2 + cn_lo)],
    [cn_maj/2,         -cn_crest/2],
    [cn_maj/2,          cn_crest/2],
    [cn_minor/2,        cn_crest/2 + cn_hi],
    [cn_minor/2 - 0.3,  cn_crest/2 + cn_hi],
];
// The FEMALE groove: the male grown by `cn_fit` all round, its +z flank (the
// ceiling, the charm printing seat-down) slackened to `cn_hi_f`.
cn_tooth_f = [
    [cn_minor/2 - 0.3, -(cn_crest/2 + cn_fit + cn_lo + cn_fit)],
    [cn_hole_min/2,    -(cn_crest/2 + cn_fit + cn_lo + cn_fit)],
    [cn_hole_maj/2,    -(cn_crest/2 + cn_fit)],
    [cn_hole_maj/2,     (cn_crest/2 + cn_fit)],
    [cn_hole_min/2,     (cn_crest/2 + cn_fit + cn_hi_f)],
    [cn_minor/2 - 0.3,  (cn_crest/2 + cn_fit + cn_hi_f)],
];

module cn_rib(i, prof, steps)
    rotate([0, 0, i * 360/steps])
        translate([0, 0, i * cn_pitch/steps])
            rotate([90, 0, 0])
                linear_extrude(0.02, center = true) polygon(prof);

// Phase 0 at z = 0, overrunning a full turn below 0 and above `len`.
module cn_helix(len, prof, steps = 30) {
    n = ceil((len + 2*cn_pitch) / cn_pitch * steps);
    translate([0, 0, -cn_pitch])
        for (i = [0 : n - 1]) hull() {
            cn_rib(i, prof, steps);
            cn_rib(i + 1, prof, steps);
        }
}

// The male thread, z = 0 .. len, tapered at the top so it finds the socket.
module cn_male(len) intersection() {
    union() {
        cylinder(d = cn_minor, h = len);
        cn_helix(len, cn_tooth);
    }
    union() {
        cylinder(d = cn_maj + 1, h = len - cn_tip);
        translate([0, 0, len - cn_tip])
            cylinder(d1 = cn_maj + 1, d2 = cn_minor - 0.4, h = cn_tip);
    }
}

// The female cutter, mouth at z = 0, up to `depth`. It overruns the mouth so
// the thread runs out THROUGH the seat face.
module cn_female(depth) intersection() {
    union() {
        translate([0, 0, -1]) cylinder(d = cn_hole_min, h = depth + 1);
        cn_helix(depth, cn_tooth_f);
    }
    translate([0, 0, -1]) cylinder(d = cn_hole_maj + 1, h = depth + 1);
}

// ------------------------------------------------------------- the pin
// Assembled, seated. Lie it down with `cn_pin_printed`.
module cn_pin() difference() {
    union() {
        // the cone and the shaft, one profile turned about the axis
        rotate_extrude($fn = 120) polygon([
            [0, cn_base],
            [cn_base_r, cn_base],
            [cn_shaft/2, -cn_sink],
            [0, -cn_sink],
        ]);
        // the shaft stops where the thread starts; the core bridges the seam,
        // so the two are welded through solid rather than across one plane
        translate([0, 0, -cn_sink - 0.1]) cylinder(d = cn_minor, h = 0.2);
        // phase still referenced to the seat face (z = 0), as the charm's is
        translate([0, 0, -cn_sink]) rotate(-cn_sink/cn_pitch*360)
            cn_male(cn_thread + cn_sink);
    }
    // the flat it prints on, the whole length
    translate([-5, -cn_flat - 5, cn_base - 1]) cube([10, 5, cn_len + 2]);
}

// Lying on its flat: assembled -y goes down, the axis runs along -y.
module cn_pin_printed() translate([0, 0, cn_flat]) rotate([90, 0, 0]) cn_pin();

// -------------------------------------------------------------- the bar
// CUT from a station bar, in the PIN's frame: the plain hole, and the
// countersink under it, which runs out through the underside.
module cn_bar_cut() {
    translate([0, 0, -cn_bar - 1]) cylinder(d = cn_hole, h = cn_bar + 2, $fn = 96);
    translate([0, 0, -cn_bar - 0.5])
        cylinder(r1 = cn_cs_r + 0.5*tan(cn_cs_a), r2 = cn_hole/2,
                 h = cn_cs_h + 0.5, $fn = 120);
}

// ------------------------------------------------------------ the charm
// CUT from a charm, z = 0 at its seat face (the bed): the thread, and the
// bore's blind end coned at 45 degrees — a flat 4.5 mm disc there would be a
// ceiling hanging over the thread.
module cn_charm_cut() {
    cn_female(cn_bore);
    translate([0, 0, cn_bore - 0.01])
        cylinder(r1 = cn_hole_min/2, r2 = 0, h = cn_hole_min/2, $fn = 96);
}
