// stem — what a charm is fixed to when the bracelet uses the U-pin mount.
//
// The H-pin's upper half — the same legs, crossbar and hooks — so it snaps
// into any charm's two holes. Its lower legs are plain stubs with no hooks,
// and a neck with a foot hangs from the crossbar's middle. The stem drops into
// a bar's pocket, and a U-pin (models/u-pin) slides in over the foot.
//
// ONE STEM PER CHARM. Snap the charm onto the stem FIRST, off the bracelet:
// its legs have to turn to let the hooks in, and in the bar they cannot. Once
// the stem is in a bar the charm is locked on it — the stub slots hug the legs,
// so they cannot turn to let it go. Lift the stem out and it comes off again,
// with the same effort as before.
//
// PRINT IT LYING FLAT, exactly as modelled — like the H-pin. In ABS: the
// crossbar bends ~6 % once, when the charm goes on.
//
// All the geometry and every number live in lib/charm-stem.scad.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-stem.scad>

copies  = 1;      // how many to lay out; `-D copies=3` for a batch
spacing = 2*hp_uo + 3;

assert(copies >= 1, "copies must be at least 1");

echo(str("stem: ", 2*hp_uo, " x ", hp_v_top - hp_v_end, " x ", hp_t,
         " mm; neck ", st_neck, ", foot ", 2*st_foot, " x ", st_foot_h,
         "; crossbar ", 100*st_strain_up, "% as the charm goes on"));

for (i = [0 : copies - 1])
    translate([i * spacing, 0, 0]) linear_extrude(hp_t) st_stem_2d();
