// pin — the dovetail H-pin that holds a charm on a bracelet.
//
// The H-pin's upper half — a crossbar and two legs with hooks pointing in —
// on a DOVETAIL instead of the H's lower legs. The charm snaps down over the
// legs exactly as it did onto the H-pin, into the same two holes. The
// dovetail slides across the band into a groove in a bar and clicks.
//
// PUT THE CHARM ON FIRST, in your hand, then push pin and charm into the bar
// from the band's edge until the pin clicks and sits flush. Once it is in,
// the charm cannot come off: its legs have no room to let go. Push the pin
// out with a toothpick from the other edge first.
//
// THE PIN IS THE SAME BOTH WAYS ROUND: a pit and a lead chamfer under each
// end of the dovetail, so it clicks whichever end goes in first.
//
// PRINT IT ON ITS SIDE, exactly as this file lays it out: the H flat on the
// bed as the H-pin printed, so its hooks are corners of an outline and the
// crossbar — the spring — flexes along its perimeters. The dovetail lies
// beside it on its foot's side; its flank leans out at 45 degrees, and the
// neck bridges 0.45 mm to the crossbar. No support.
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
         " mm on its side; neck ", 2*dt_w_lo, " x ", dt_neck_y,
         "; crossbar ", hp_cb_h, " at ", 100*dt_strain_up, "% per charm (x", dt_stiffen,
         " the H-pin's grip); a leg's foot would swing to ", dt_leg_foot,
         " to let a charm go, the channel stops it at ", dt_waist,
         "; leaf bent ", dt_preload, " at rest and ", dt_ride, " going in (",
         100*dt_strain, "%)"));

// Laid on its side: the assembled x (along the band) becomes up, so the H's
// face and the dovetail's foot both land on the bed.
module pin_printed() translate([0, 0, hp_t/2]) rotate([0, -90, 0]) dt_pin();

for (i = [0 : copies - 1])
    translate([i * spacing, 0, 0]) pin_printed();
