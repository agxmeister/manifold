// cone-pin — the bolt every charm is held by.
//
// It goes into a station bar FROM UNDERNEATH: the cone at its foot seats in
// the bar's countersink, flush with the band's underside, and the M5 thread
// stands up out of the bar's top.
//
// TO PUT A CHARM ON: set the charm on the bar with the bar's RIB in two of
// its grooves, at the angle you want (every 45 degrees). Push the bolt up
// into the bar from below and turn it with the hex key (models/screwdriver)
// in the socket in its foot — clockwise, seen from below — until it pulls
// the charm down tight. The charm cannot turn: the rib holds it, so the
// BOLT turns, spinning in its round countersink. To take the charm off or
// turn it, unscrew the bolt the same way.
//
// The socket takes a `cn_key` (3 mm) hex key.
//
// PRINT IT STANDING UP, on its foot, exactly as this file lays it out, in
// ABS. Round all the way up: no flat side, no support.
//
// All the geometry and every number live in lib/charm-cone.scad, beside the
// bar's hole and the charm's socket they have to match.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-cone.scad>

copies  = 1;      // how many to lay out; `-D copies=6` for a batch
spacing = 2*cn_cs_r + 3;   // centre to centre, in a row

assert(copies >= 1, "copies must be at least 1");

echo(str("cone pin: ", cn_len, " mm long, M", cn_maj, " x ", cn_pitch, " (",
         cn_turns, " turns), cone ", 2*cn_cs_r, " at ", cn_cs_a,
         " deg (shoulder ", cn_seat, "); foot ", cn_recess,
         " inside the bar; hex socket ", cn_key_af, " AF x ", cn_key_d,
         " (wall ", cn_key_wall_min, ")"));

for (i = [0 : copies - 1])
    translate([i * spacing, 0, 0]) cn_pin_printed();
