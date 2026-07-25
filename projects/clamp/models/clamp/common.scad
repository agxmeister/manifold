// common — every dimension, fit and derived layout number the clamp's five
// parts share. Include this from a part; it defines variables, functions and
// two tiny helper modules only, so including it renders nothing on its own.
//
// Coordinate system ("use orientation", what every clamp_*() module builds):
//
//     +Z = up the bar, toward the fixed jaw
//     +X = out along the throat, from the bar toward the screw axis
//     +Y = across the bar's width (the thin direction)
//
// The bar's cross-section occupies x = [0, bar_x], y = +/- bar_y/2, and its
// bottom end sits at z = 0. Each part file rotates its module into the
// orientation it actually prints in.

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn = 64;

// ---- The spec: how wide the clamp opens ----
// The sliding jaw is pinned to one of `notch_count` holes for the coarse
// setting; the screw covers the `travel` between holes and does the clamping.
capacity_min = 0;    // opening at the top hole with the screw wound fully in
notch_pitch  = 10;   // pin-hole spacing along the bar
notch_count  = 8;

// ---- Bar ----
bar_x  = 20;   // depth, along the throat — the bar's bending-strong axis
bar_y  = 12;   // width — also the frame's height on the print bed
throat = 55;   // bar front face -> screw axis

// ---- Fixed jaw (the top of the frame) ----
jaw_root_t   = 18;   // arm thickness where it meets the bar
jaw_tip_t    = 12;   // arm thickness at the tip
jaw_overhang = 14;   // how far the jaw reaches past the screw axis

// ---- Sliding jaw ----
collar_wall = 6;
collar_h    = 30;    // collar and boss share this height
arm_w       = 26;
boss_d      = 26;
boss_h      = collar_h;
min_engage  = 14;    // shortest thread engagement we allow the screw to reach

// ---- Screw ----
// A deliberately coarse, deliberately blunt trapezoidal thread. BOSL2 measures
// thread_angle between the two flanks, each sitting thread_angle/2 off the
// *radial* direction — so 100 degrees puts the flanks 40 degrees off vertical,
// self-supporting when the part is printed axis-up. Holding that angle while
// keeping a real land on the crest and root is what forces the coarse pitch:
// each flank eats thread_dep*tan(50) = 1.4 mm of the pitch.
thread_d   = 16;
thread_p   = 4;
thread_a   = 100;
thread_dep = 1.2;   // 0.57 mm of land left on crest and root
screw_shank = 47;
lever_l = 84;    // tommy lever, tip to tip
lever_w = 26;
lever_t = 14;
neck_d  = 9;     // waist below the ball, so the pad can swivel
neck_h  = 8;
ball_d  = 13;
ball_up = 12;    // ball centre above the top of the threaded shank

// ---- Swivel pad ----
pad_d        = 24;  // the clamping face
pad_face_t   = 5;   // solid material above the socket — carries the whole load
pad_barrel_d = 18;  // thin-walled collet barrel: 2.4 mm of wall at the equator
pad_barrel_h = 9;   // how far the fingers reach below the ball's equator
pad_slots    = 4;
pad_slot_w   = 1.4;

// ---- Locking pin ----
pin_d      = 8;
pin_head_l = 22;
pin_head_w = 12;
pin_head_t = 4;

// ---- Fits (see the README) ----
slide_gap   = 0.35;  // slider bore vs bar — loose, it has to slide freely
pin_gap     = 0.25;  // pin vs its holes — removable by hand
pad_gap     = 0.2;   // socket vs ball — free swivel
pad_lip     = 0.4;   // per-side interference retaining the pad: a real snap,
                     //   sized against the finger's length, not by eye
thread_slop = 0.1;   // BOSL2 $slop; adds 4x this to the internal thread

// ---- Derived layout ----
x_screw  = bar_x + throat;             // screw axis
bore_x   = bar_x + 2 * slide_gap;      // slider's bore around the bar
bore_y   = bar_y + 2 * slide_gap;
collar_x = bore_x + 2 * collar_wall;
collar_y = bore_y + 2 * collar_wall;

travel    = boss_h - min_engage;                  // fine adjustment, one pin hole
socket_r  = (ball_d + pad_gap) / 2;
pad_face_z = socket_r + 1 + pad_face_t;           // ball centre -> pad face
pad_reach  = ball_up + pad_face_z;                // shank top  -> pad face

// The pin sits at the collar's mid-height and the boss shares the collar's z
// span, so everything above is a fixed offset from the pin's hole. This is the
// screw wound all the way in — its shank bottomed on the boss, the pad at its
// highest. Winding it back out lowers the pad, by up to `travel`.
pad_face_above_pin = collar_h / 2 + (screw_shank - boss_h) + pad_reach;

hole_z0  = 20;                                    // lowest pin hole
hole_top = hole_z0 + (notch_count - 1) * notch_pitch;
function hole_z(i) = hole_z0 + i * notch_pitch;

// Place the jaw so the top hole with the screw fully in gives capacity_min.
jaw_face_z   = hole_top + pad_face_above_pin + capacity_min;
bar_len      = jaw_face_z + jaw_root_t;
capacity_max = capacity_min + (notch_count - 1) * notch_pitch + travel;

// ---- Helpers ----

// A 2D teardrop: a circle with a 45-degree apex on top, so a hole bored
// sideways through a part still prints without a sagging crown.
module teardrop2d(r) {
    hull() {
        circle(r = r);
        polygon([[-0.01, 0], [0.01, 0], [0, r * sqrt(2)]]);
    }
}

// The bar's own cross-section, grown by `gap` per side — the profile the
// slider's bore is cut from.
module bar_section(gap = 0) {
    translate([bar_x / 2, 0])
        square([bar_x + 2 * gap, bar_y + 2 * gap], center = true);
}
