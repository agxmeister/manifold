// jar-cap — shared dimensions and geometry. Renders nothing on its own.
//
// One frame for every model, the USE frame: the jar stands upright, z = 0 is
// the underside of a cap's ceiling, and the jar's flange sits just below it,
// pressed up against the seal bead. Each model file flips its part into its
// own print pose at the bottom.

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn = 160;

// ---- Jar (measured: Milbona 450 g yogurt pot) ----------------------------
flange_d = 94.0;    // outer diameter across the flange
flange_h = 1.2;     // flange height, top surface to bottom edge
neck_d   = 85.4;    // jar wall just below the flange (straight for ~10 mm)

// ---- Cap body, shared by both caps --------------------------------------
top_t  = 1.6;       // ceiling thickness
wall   = 1.6;       // skirt wall thickness
bead_h = 0.6;       // seal bead under the ceiling, presses the flange's top
bead_w = 1.2;       // seal bead width at its base
ribs   = 36;        // grip ribs around the outside
rib_r  = 0.9;

bead_r       = (flange_d / 2 + neck_d / 2) / 2;   // bead sits mid-flange
flange_top_z = -bead_h;                           // flange seated on the bead
flange_bot_z = flange_top_z - flange_h;

// ---- Screw option: thread shared by collar and screw-cap -----------------
// The clamp project's thread, proven on a print: BOSL2 trapezoidal, flanks
// 40° off vertical so both the collar's external and the cap's internal
// thread print support-free with their axes vertical.
thread_d     = 102;     // major diameter; the minor must clear the flange
thread_p     = 4;
thread_a     = 100;
thread_dep   = 1.2;
thread_slop  = 0.1;     // BOSL2 $slop; adds 4x this to the internal thread
thread_l     = 8;       // engaged length, two turns

thread_minor = thread_d - 2 * thread_dep;
assert(thread_minor / 2 > flange_d / 2 + 1,
       "the cap's thread crests would hit the jar's flange");

// ---- Shared modules ------------------------------------------------------

// A cup: ceiling over z in [0, top_t], skirt of inner radius `ri` hanging
// `h` below it, grip ribs outside. `ro` defaults to `ri + wall`.
module cap_shell(ri, h, ro = undef) {
    r_out = is_undef(ro) ? ri + wall : ro;
    difference() {
        union() {
            translate([0, 0, -h]) cylinder(r = r_out, h = h + top_t);
            for (i = [0:ribs-1]) rotate(i * 360 / ribs)
                translate([r_out, 0, -h])
                    cylinder(r = rib_r, h = h + top_t, $fn = 16);
        }
        translate([0, 0, -h - 1]) cylinder(r = ri, h = h + 1);
    }
}

// Annular bead under the ceiling, the only thing touching the flange's top.
module seal_bead() {
    rotate_extrude()
        polygon([[bead_r - bead_w/2, 0.01], [bead_r + bead_w/2, 0.01],
                 [bead_r + bead_w/4, -bead_h], [bead_r - bead_w/4, -bead_h]]);
}

// Cap's print pose: ceiling down on the bed, skirt up.
module cap_print_pose() { translate([0, 0, top_t]) rotate([180, 0, 0]) children(); }
