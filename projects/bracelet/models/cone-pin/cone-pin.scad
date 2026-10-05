// cone-pin — the cone pin a `mount = "cone"` charm screws onto.
//
// It goes into a station bar FROM UNDERNEATH: the cone at its foot seats in
// the bar's countersink, flush with the band's underside, and the M5 thread
// stands up out of the bar's top. Hold it there with a finger and screw the
// charm down onto it until it is tight: the charm clamps the bar between
// itself and the cone. To turn a charm, loosen it, turn it, tighten it again.
//
// PRINT IT LYING DOWN, on its flat, exactly as this file lays it out, in ABS
// as the H-pins were. No support.
//
// All the geometry and every number live in lib/charm-cone.scad, beside the
// bar's hole and the charm's socket they have to match.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-cone.scad>

copies  = 1;      // how many to lay out; `-D copies=6` for a batch
spacing = 2*cn_cs_r + 3;   // centre to centre, side by side

assert(copies >= 1, "copies must be at least 1");

echo(str("cone pin: ", cn_len, " mm long, M", cn_maj, " x ", cn_pitch, " (",
         cn_turns, " turns), cone ", 2*cn_cs_r, " at ", cn_cs_a,
         " deg (shoulder ", cn_seat, "); flat ", cn_flat, " off the axis"));

for (i = [0 : copies - 1])
    translate([i * spacing, 0, 0]) cn_pin_printed();
