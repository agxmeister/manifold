// charm-h-pin — the loose H-shaped pin that snaps a charm onto a bracelet.
//
// Two legs and a crossbar, a hook at every leg end. The lower half pushes
// down into a pocket in a bracelet bar until the crossbar bottoms out and the
// lower hooks snap under the pocket's shoulders; the charm then pushes down
// over the upper half and the upper hooks snap into its holes. The crossbar
// ends up sunk in the bar, the charm sits flat on the bar, and the pin is not
// on show anywhere.
//
// THE TWO HALVES ARE THE SAME LENGTH BUT NOT THE SAME. The half whose hooks
// point OUTWARD goes into the bracelet; the half whose hooks point INWARD takes
// the charm.
//
// PRINT IT LYING FLAT, exactly as modelled. That is the whole trick of this
// part: the H is a 2D outline extruded `hp_t` straight up, so its hooks are
// just corners of the outline and there is nothing on it that overhangs. The
// crossbar — the spring — flexes in the plane of the bed, along its perimeters.
//
// Both halves go in the same way: the legs TURN and the crossbar bends between
// them. Into the bar, the upper legs splay out as the lower hooks go in; onto
// the charm, the upper legs splay out again and the lower hooks back off their
// shoulders a little, then everything springs home. Put the pin in the
// bracelet first, then the charm on the pin.
//
// All the geometry and every number live in lib/charm-pin.scad, beside the
// pockets and holes they have to match.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

copies  = 1;      // how many to lay out; `-D copies=6` for a batch
spacing = 2*(hp_uo + hp_hook) + 3;   // centre to centre, side by side

assert(copies >= 1, "copies must be at least 1");

echo(str("H-pin: ", 2*(hp_uo + hp_hook), " x ", hp_v_top - hp_v_end, " x ", hp_t,
         " mm, legs ", hp_leg_w, " wide at ", 2*hp_s, " apart; ",
         -hp_v_end, " mm into the bar, ", hp_v_top, " into the charm"));
echo(str("hooks ", hp_hook, " (", hp_defl, " past the wall), lead-in ", hp_lead,
         " deg into the bar, ", hp_lead_up, " into the charm; catch 45 deg in the bar, ",
         hp_catch_up, " deg in the charm; levers ", hp_arm_lo, " / ", hp_arm_up,
         "; crossbar ", hp_cb_h, " at ", 100*hp_strain_cb, "% strain; lower hooks keep ",
         hp_keep, " when the charm lets go"));

module charm_h_pin_printed() linear_extrude(hp_t) hp_pin_2d();

for (i = [0 : copies - 1])
    translate([i * spacing, 0, 0]) charm_h_pin_printed();
