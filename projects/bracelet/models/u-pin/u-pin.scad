// u-pin — holds a charm's stem (models/stem) in the bracelet.
//
// A flat U. Its two legs slide along the band through the charm bar, either
// side of the stem's neck and just over its foot, until the closed end (the
// bight) meets the bar's face. The legs' tips then sit flush with the bar's
// far face.
//
// TO FIT OR REMOVE IT, fold the joint BEFORE the charm bar — the one on the
// bight's side — forward, the way a wrist bends it, but to ~80-85 degrees.
// Until then the lock tooth on that bar leaves the U-pin only 2.0-2.8 mm to
// move (by wrist size), and it needs 4.75 to let the stem go. On a wrist a
// joint turns ~36.
// Push it out from the far side with a toothpick on the leg tips.
//
// PRINT IT LYING FLAT, exactly as modelled.
//
// All the geometry and every number live in lib/charm-stem.scad. It is drawn
// for a 6.0 mm bar, the bracelet's `body`.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-stem.scad>

body    = 6.0;    // the bar it goes through, along the band — bracelet.scad's `body`
copies  = 1;      // how many to lay out; `-D copies=3` for a batch
spacing = 2*st_co + 3;

assert(copies >= 1, "copies must be at least 1");

echo(str("U-pin: ", body + st_bight, " x ", 2*st_co, " x ", st_ch,
         " mm, legs ", st_lw, " wide, ", 2*st_ci, " apart inside"));

for (i = [0 : copies - 1])
    translate([0, i * spacing, 0]) linear_extrude(st_ch) st_upin_2d(body);
