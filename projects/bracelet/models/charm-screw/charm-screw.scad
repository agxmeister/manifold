// charm-screw — the loose double-ended screw that hangs a charm on a bracelet.
//
// The smallest part in the project and the only one attached to nothing: a
// hex-collared screw with a MALE THREAD ON BOTH ENDS. The long end winds down
// into a threaded hole straight through a bracelet bar until the collar seats
// on the bar's top face; the short end is what a charm winds onto. Nothing
// here is permanent and nothing here springs — with the fused ball pin a charm
// came off but the pin stayed on the bracelet forever, and with this the
// bracelet is just a strip with threaded holes in it.
//
// THE TWO ENDS ARE NOT INTERCHANGEABLE. The bar end is longer (it has a whole
// 4.45 mm bar to get through) and stops `scr_sink` shy of the bar's underside
// so nothing ever protrudes against the wrist. Fit the long end to the
// bracelet. Both threads are right-handed, so tightening the charm also
// tightens the screw into its bar, and unscrewing the charm tends to bring the
// screw out with it — which is fine, it is a joint that is meant to come
// apart, and the two then unscrew from each other.
//
// PRINT IT LYING DOWN, flat on the bed, exactly as modelled here.
//
// A screw is a tower of tangent ledges printed standing up: 9 mm tall on a
// 3 mm circle, every thread crest leaving the previous layer at the tangent.
// Lying down it is a horizontal cylinder, and a horizontal cylinder's only
// real problem is its underside — cut off here by `scr_flat`, exactly as
// `pin_flat` does for the hinge pin in bracelet.scad. The thread is gone over
// the ~90 degrees of arc the flat eats; the other 270 hold, and a charm is not
// a load. The flat sits a hair INSIDE the core radius on purpose, so the
// groove roots reach the bed too and the contact patch runs unbroken along the
// whole shaft rather than stopping at each crest.
//
// It is a 9 x 5 x 3.5 mm part, so print a batch: `-D copies=6`.
//
// All the geometry and every number live in lib/charm-pin.scad, beside the
// threaded holes they have to match. Nothing about this screw can be changed
// here alone.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

copies  = 1;      // how many to lay out. 1 for the checks; raise it to print a
                  //   batch. The export is then `copies` separate shells,
                  //   which is correct, not a fault.
spacing = 7;      // centre to centre, across the shafts. Clear of the 4.85 mm
                  //   collar with room to get a fingernail between them.

assert(copies >= 1, "copies must be at least 1");
assert(spacing > 2*scr_r_out + 2, "the screws are too close together to pick up");

echo(str("screw: ", scr_len, " mm long overall — ", scr_bar - scr_sink,
         " into the bar, ", scr_collar_h, " collar, ", scr_charm,
         " into the charm"));
echo(str("thread M", scr_maj, " x ", scr_pitch, ", depth ", scr_depth,
         ", fit ", scr_fit, " — ", scr_turns_bar, " turns in the bar, ",
         scr_turns_charm, " in the charm"));
echo(str("printed flat: ", scr_flat_w, " mm of first layer under the shaft, ",
         "shaft leaves the bed at ", scr_crest_ov, " deg from vertical"));
echo(str("female ceiling ", scr_ceiling, " deg from vertical, female crest ",
         scr_crest_f, " mm wide"));

// Roll it onto its flat: the screw is modelled standing on z with the flat cut
// at y = +scr_flat, so -90 about x lays the axis along y and puts that flat
// face down. The lift is what lands it exactly on the bed.
module charm_screw_printed()
    translate([0, 0, scr_flat]) rotate([-90, 0, 0]) charm_screw();

module charm_screw_batch() {
    for (i = [0 : copies - 1])
        translate([i * spacing, 0, 0]) charm_screw_printed();
}

charm_screw_batch();
