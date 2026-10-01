// pin — the dovetail H-pin that holds a charm on a bracelet.
//
// Two legs with hooks pointing in, like the H-pin's upper half, standing on
// a solid block on a DOVETAIL. The charm snaps down over the legs as it did
// onto the H-pin, into the same two holes; the legs are the spring now,
// each in a slot in the block. The dovetail slides across the band into a
// groove in a bar and clicks.
//
// PUT THE CHARM ON FIRST, in your hand, then push pin and charm into the bar
// from the band's edge until the pin clicks and sits flush. To take the
// charm off, push the pin out with a toothpick first.
//
// THE PIN IS THE SAME BOTH WAYS ROUND: a pit and a lead chamfer under each
// end of the dovetail, so it clicks whichever end goes in first.
//
// PRINT IT ON ITS SIDE, exactly as this file lays it out: the H flat on the
// bed as the H-pin printed, so its hooks are corners of an outline and the
// legs flex in the bed plane, along their perimeters. The dovetail's foot
// lies on the bed beside the block, its flank leaning out at 45 degrees.
// No support.
//
// All the geometry and every number live in lib/charm-dovetail.scad, and the
// H's in lib/charm-pin.scad, beside the groove and holes they have to match.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-dovetail.scad>

copies  = 1;      // how many to lay out; `-D copies=6` for a batch
spacing = (hp_v_top - dt_bot) + 3;   // centre to centre, side by side

assert(copies >= 1, "copies must be at least 1");

echo(str("dovetail H-pin: ", dt_len, " x ", hp_v_top - dt_bot, " x ", hp_t,
         " mm on its side; legs ", dt_leg_t, " on a ", dt_leg_a, " lever, hooks ", dt_hook,
         " (", dt_leg_d, " over the shoulder), ", 100*dt_leg_strain,
         "% per charm; dovetail grip ", dt_grip, " a side; leaf bent ", dt_preload, " at rest and ", dt_ride,
         " going in (", 100*dt_strain, "%)"));

// Laid on its side: the assembled x (along the band) becomes up, so the H's
// face and the dovetail's foot both land on the bed.
module pin_printed() translate([0, 0, hp_t/2]) rotate([0, -90, 0]) dt_pin();

for (i = [0 : copies - 1])
    translate([i * spacing, 0, 0]) pin_printed();
