// charm-dovetail — how a charm hangs on the bracelet: the DOVETAIL H-PIN.
//
// The pin is two proven halves fused into one solid block:
//
//   * its BOTTOM is a DOVETAIL, 16 mm long, running ACROSS the band. It slides
//     into a dovetail groove through a station bar, from the band's edge, and
//     CLICKS: a LIP on a spring leaf in the groove's floor drops into a PIT
//     under the pin;
//   * its TOP is the H-PIN's upper half (lib/charm-pin.scad) — the crossbar and
//     the two hooked legs, exactly, so every charm's two holes fit it
//     unchanged. Its crossbar runs in a shallow CHANNEL across the bar top,
//     sunk `hp_recess` like the H-pin's.
//
// A SOLID BLOCK WITH SOLID LEGS (2026-10-02). Under the legs the pin is one
// block, the whole pin's length, from the dovetail up to the crossbar's top
// (`hp_cb_top`), and the legs grow straight out of it. Nothing on the pin
// flexes: a charm snaps on by its own give and the hooks'. History: a 0.8 mm
// neck joined the dovetail to a bending H crossbar (0d41592, printed well);
// then the legs were springs in slots, first in the block, then down through
// the dovetail. The user found the slots made the legs "very fragile" and had
// them removed.
//
// PUT THE CHARM ON THE PIN FIRST, in your hand: press it down over the legs
// until it snaps, as with the H-pin. Then push pin and charm into the bar from
// the band's edge until the pin clicks. Push the pin out from the other edge
// with a toothpick to take the charm off, then pull the charm off the pin.
//
// THE LEAF IS THE SPRING of the click. Its lip rides the pin's underside for
// the last 3 mm going in, dipping `dt_ride` below the band's underside — so
// push the pin in with the band in your hand, not flat on a table. At rest it
// is still bent `dt_preload`, pressing the pin UP against the groove's flanks,
// so the pin does not rattle in the bar. On the wrist the skin holds the leaf
// up: the pin cannot be pushed out while it is worn.
//
// THE PIN PRINTS ON ITS SIDE, its H flat on the bed as the H-pin printed, so
// its hooks are corners of an outline. The dovetail's foot lies on the bed
// beside it, its flank leaning out at 45 degrees, and the fill joins them.
//
// This file draws nothing — variables, functions and modules only. It
// includes lib/charm-pin.scad for the H's upper half and the charms' holes;
// everything new is named `dt_*`.
//
// FRAME (assembled): x along the band, y across it, z = 0 the bar's top face,
// which is also the charm's seat. The station bar's centre is x = y = 0. The
// pin goes into the bar moving -y and is drawn UP: pushed up by the leaf until
// its dovetail's flanks bear on the groove's.
//
//      across the band (x, z)                 along the band (y, z)
//                                         charm  |< >|     |< >|  upper legs
//      charm  |   |   <- a leg            -------|   |-----|   |-- bar top
//   ----------|   |-------- bar top              |===============|  crossbar
//      bar    |___|  <- crossbar, in the channel  |###############| <- fill
//             |###|  <- fill            ________/_________________ dovetail
//             /___\  <- dovetail          lip on the leaf ^
//             |___|
//          ==/\=====  lip on the leaf

include <charm-pin.scad>

// --------------------------------------------------------------- the channel
dt_ch_w    = hp_slot_x;    // the channel's width along the band: the H's
                           //   slots in every charm, 0.15 round its 3.5
dt_waist   = -0.8;         // the dovetail's waist, and the block's underside.
                           //   -1.6 until 2026-10-02: the pin's base was 2.95
                           //   tall and the groove so deep the bars bent with
                           //   a pin in. Now the base is 2.0 and the block 0.5

// ----------------------------------------------------- the dovetail (x, z)
dt_bar     = 4.2;    // the bar's thickness == the band's `thick`, asserted there
dt_floor   = 1.75;   // bar under the groove: 0.8 until 2026-10-02, when it
                     //   was also the leaf, and the bar bent at the station
dt_leaf_t  = 1.0;    // the leaf's thickness, at the bottom of a pocket in
                     //   that floor. Its stiffness goes as its cube
dt_foot_h  = 0.5;    // the foot's straight sides — on its side the pin stands
                     //   on this strip, so a bead's width at least. The waist
                     //   is whatever the 45-degree flanks leave above it
dt_a_lo    = 45;     // the flanks, degrees from vertical: a ceiling in the bar,
                     //   an overhang on the pin as it prints on its side
dt_foot    = hp_t/2; // the foot's half-width — the H's, so both stand on the
                     //   bed side by side when the pin prints on its side
dt_side    = 0.2;    // groove to foot, on the foot's vertical sides
dt_gv      = 0.15;   // the pin's bottom over the groove's floor, UP — and
                     //   the fill's underside over the channel's floor: the
                     //   room the pin has to sit lower if it prints fat

// --------------------------------------------------------------- the legs
dt_leg_t   = 1.0;    // a leg's thickness across the band. 0.8 until
                     //   2026-10-02: printed "very weak". The H-pin's was 1.6,
                     //   on a crossbar that bent
dt_hook    = 0.75;   // how far a hook stands in from its leg (the H-pin's 1.0):
                     //   it laps the charm's shoulder by `dt_hook - hp_fit`.
                     //   0.62 until 2026-10-02: printed "very small"

// ------------------------------------------------- the pin's length and click
dt_len     = 16.0;   // the pin, across the band: the band's width less 0.1
                     //   each end, so it sits flush (asserted in bracelet.scad)
dt_lead    = 0.7;    // 45-degree chamfer under each end: the lip rides up it
                     //   onto the pin's underside, so it must out-reach `dt_ride`
dt_y_lip   = -6.0;   // the lip, and the pit over it
dt_lip_h   = 0.7;    // the lip over the groove's floor, unbent
dt_lip_top = 0.3;    // its flat crest
dt_lip_w   = 1.1;    // the lip's half-width across the leaf, and the pit's
                     //   less `dt_pit_c`: narrower than the foot, so the pit
                     //   leaves 0.5 of the foot whole at each edge
dt_click_a = 30;     // the lip's and the pit's flanks, degrees from VERTICAL.
                     //   45 until 2026-10-02, when the pin slid out sideways:
                     //   at 30 a push frees it only about twice as hard. The
                     //   pin goes in over its 45-degree lead chamfer, so only
                     //   leaving needs the steep flank
dt_pit     = 0.45;   // the pit's depth into the pin's underside. The lip
                     //   has to bend `dt_pit` more to leave it (0.35 before)
dt_pit_c   = 0.05;   // the pit's flanks clear of the lip's, so the lip's
                     //   crest is what bears
dt_slot    = 0.5;    // the slots round the leaf, through the floor: the
                     //   first layer needs 0.5 to keep them open
dt_leaf_l  = 6.45;   // the leaf, root to tip (the tip is at -y): long enough
                     //   for the 1.0 leaf's ride at 2.5 %

// ------------------------------------------------------------------ derived
dt_fl_top = dt_floor - dt_bar;                          // -2.45 groove floor
dt_bot    = dt_fl_top + dt_gv;                          // -2.30 pin's bottom, UP
dt_hf     = dt_waist - dt_bot - dt_foot_h;              // 1.00 flanks' height
dt_w_lo   = dt_foot - dt_hf * tan(dt_a_lo);             // 0.75 waist's half-width
dt_ch_fl  = dt_waist - dt_gv;                           // -0.95 channel's floor
dt_ch_d   = -dt_ch_fl;                                  // 0.95 channel's depth
dt_g_w    = dt_foot + dt_side;                          // 1.95 groove's foot, half
dt_g_fz   = dt_waist - (dt_g_w - dt_w_lo) / tan(dt_a_lo);   // -2.00 where its flank starts
dt_leaf_w = dt_g_w - dt_slot;                           // 1.45 leaf, half-width
dt_lip_base = dt_lip_top/2 + dt_lip_h * tan(dt_click_a);  // 0.55 the lip's half-base,
                                                        //   at the groove floor's level
dt_pocket = dt_floor - dt_leaf_t;                       // 0.75 the pocket over the leaf:
                                                        //   the lip stands on a post that tall
dt_tip    = dt_y_lip - dt_lip_base - 0.15;              // -6.70 leaf's tip
dt_root   = dt_tip + dt_leaf_l;                         // -0.25 leaf's root
dt_preload = dt_lip_h - dt_gv - dt_pit;                 // 0.10 leaf bent at rest
dt_ride   = dt_lip_h - dt_gv;                           // 0.55 bent under the pin

// The legs: solid, from the block up.
dt_leg_uo  = hp_ui_g + dt_leg_t;                        // 4.50 a leg's outer face
dt_tip_bot = hp_v_uc + dt_hook / tan(hp_catch_up);      // 1.63
dt_tip_top = dt_tip_bot + hp_tip_up;                    // 2.23
dt_leg_d   = dt_hook - hp_fit;                          // 0.60 over the charm's shoulder

// The leaf is a cantilever loaded near its tip: strain at the root is
// 3 * t * d / (2 a^2), a = root to lip.
dt_leaf_a = dt_root - dt_y_lip;
dt_strain = 3 * dt_leaf_t * dt_ride / (2 * dt_leaf_a * dt_leaf_a);

assert(dt_waist < hp_cb_top - 0.4, "the block under the legs is under 0.4 tall");
// The groove's flank meets the channel's floor `dt_gv` below the waist, so
// that much of the pin's flank is not covered: the overlap that holds is
// `dt_grip` a side.
dt_grip   = dt_foot - (dt_w_lo + dt_gv * tan(dt_a_lo));  // 0.85
assert(dt_leg_uo + hp_fit <= hp_h_out, "a leg runs into the charm hole's outer wall");
assert(hp_ui_g - dt_hook - hp_fit >= hp_h_in - 1e-9, "a hook runs into the charm chamber's inner wall");
// the hook's lead-in, from its tip's top to the leg's top, under the chamber's roof
assert(min([for (u = [hp_ui_g - dt_hook : 0.05 : hp_ui_g - hp_fit])
            hp_c_rf(u) - (dt_tip_top + (u - (hp_ui_g - dt_hook)) * (hp_v_top - dt_tip_top) / dt_hook)])
       >= hp_gap, "the charm's chamber roof comes down onto the hook's lead-in");
assert(dt_leg_d >= 0.6 - 1e-9, "the hooks lap the charm's shoulder by under 0.6 — they printed too small at 0.47");
assert(dt_foot - (dt_lip_w + dt_pit_c) >= 0.5, "the pit leaves under 0.5 of the foot at its edges");
assert(dt_lip_w <= dt_leaf_w, "the lip is wider than its leaf");
assert(dt_leg_t >= 1.0, "the legs are under 1.0 — they printed too weak at 0.8");
assert(dt_lead >= dt_ride + 0.1, "the lip's crest meets the pin's end under its lead chamfer — it jams going in");
assert(dt_grip >= 0.5, str("the groove holds the dovetail by only ", dt_grip, " a side"));
assert(dt_foot_h >= 0.5,
       str("the dovetail's foot is ", dt_foot_h, " straight — the pin stands on it, on its side, and needs a bead's width"));
assert(dt_w_lo >= 0.5, str("the dovetail's waist is only ", 2*dt_w_lo, " wide"));
assert(dt_a_lo <= 45, "the flanks: 45 degrees at most");
assert(dt_preload > 0, "the leaf does not press the pin up at rest — it rattles");
assert(dt_pit >= 0.3, "the lip sits too shallow in the pit to hold");
assert(dt_strain <= 0.025,
       str("the leaf bends to ", 100*dt_strain, "% as the pin goes in — past 2.5% in PLA"));
assert(dt_tip - dt_slot >= -dt_len/2,
       "the leaf's end slot runs out past the pin's end");

// ------------------------------------------------------------------ the pin
// The dovetail's outline, one side, in (x, z).
function dt_lo_pts() = [
    [0,        dt_bot],
    [dt_foot,  dt_bot],
    [dt_foot,  dt_waist - dt_hf],
    [dt_w_lo,  dt_waist],
    [0,        dt_waist],
];

module dt_sym2d(pts) { polygon(pts); mirror([1, 0]) polygon(pts); }

// The dovetail, running along y, with the lead chamfers under both ends and
// the two pits: one each end, so the pin goes in either way round.
module dt_pin_lo() difference() {
    rotate([90, 0, 0]) linear_extrude(dt_len, center = true) dt_sym2d(dt_lo_pts());
    for (s = [-1, 1]) {
        translate([0, s*dt_len/2, dt_bot]) rotate([45, 0, 0])
            cube([2*dt_foot + 1, dt_lead*sqrt(2), dt_lead*sqrt(2)], center = true);
        // the pit, only as wide as the lip (and `dt_pit_c`), so the foot's
        // edges under the flanks stay whole
        translate([0, s*dt_y_lip, dt_bot]) rotate([90, 0, 90])
            linear_extrude(2*(dt_lip_w + dt_pit_c), center = true)
                polygon([[-(dt_lip_top/2 + dt_pit_c + dt_pit*tan(dt_click_a)), -0.01],
                         [  dt_lip_top/2 + dt_pit_c + dt_pit*tan(dt_click_a),  -0.01],
                         [  dt_lip_top/2 + dt_pit_c, dt_pit],
                         [-(dt_lip_top/2 + dt_pit_c), dt_pit]]);
    }
}

// The block: the pin's full length and the H's full thickness, from the
// waist up to the crossbar's top.
module dt_block() translate([-hp_t/2, -dt_len/2, dt_waist - 0.01])
    cube([hp_t, dt_len, hp_cb_top - dt_waist + 0.01]);

// One leg, the one at +u, in (u, v): the H-pin's upper leg with its inner
// face and its hook's catch where they were (so the charm's shoulder still
// meets it), thinner on the outside, the hook shorter. It is drawn down into
// the block, so the two fuse.
function dt_leg_pts() = [
    [hp_ui_g,           dt_waist],
    [dt_leg_uo,         dt_waist],
    [dt_leg_uo,         hp_v_top],
    [hp_ui_g,           hp_v_top],
    [hp_ui_g - dt_hook, dt_tip_top],      // the lead-in, from the leg's top
    [hp_ui_g - dt_hook, dt_tip_bot],      // the tip's flat
    [hp_ui_g,           hp_v_uc],         // the catch, at `hp_catch_up`
];
module dt_legs() hp_stand(hp_t) dt_sym2d(dt_leg_pts());

// The pin, ASSEMBLED and UP. models/pin lays it on its side to print.
module dt_pin() union() { dt_pin_lo(); dt_block(); dt_legs(); }

// ----------------------------------------------------------------- the bar
// The groove's outline, one side, in (x, z): the foot, the flank the pin's
// bears on, up to the channel's floor, and the channel.
function dt_groove_pts() = [
    [0,       dt_fl_top],
    [dt_g_w,  dt_fl_top],
    [dt_g_w,  dt_g_fz],
    [dt_w_lo + dt_gv*tan(dt_a_lo), dt_ch_fl],
    [dt_ch_w/2, dt_ch_fl],
    [dt_ch_w/2, 1],
    [0,       1],
];

// What a station cuts from its bar, z = 0 at the bar's top: the channel and
// the groove under it, right through the bar across the band, and the slots
// that free the leaf.
module dt_bar_cut() {
    rotate([90, 0, 0]) linear_extrude(40, center = true) dt_sym2d(dt_groove_pts());
    // the pocket over the leaf and its slots, down to the leaf's top
    translate([-dt_g_w, dt_tip - dt_slot, -dt_bar + dt_leaf_t])
        cube([2*dt_g_w, dt_root - (dt_tip - dt_slot), dt_pocket + 0.01]);
    translate([0, 0, -dt_bar - 1]) {
        for (s = [-1, 1])        // along the leaf's sides
            translate([s > 0 ? dt_leaf_w : -dt_g_w, dt_tip - dt_slot, 0])
                cube([dt_slot, dt_root - (dt_tip - dt_slot), dt_leaf_t + 1.01]);
        translate([-dt_g_w, dt_tip - dt_slot, 0])     // across its tip
            cube([2*dt_g_w, dt_slot, dt_leaf_t + 1.01]);
    }
}

// What a station adds to its bar once cut: the lip on the leaf, on a post up
// out of the pocket to the groove floor's level.
module dt_bar_add() {
    translate([0, dt_y_lip, dt_fl_top]) rotate([90, 0, 90])
        linear_extrude(2*dt_lip_w, center = true)
            polygon([[-dt_lip_base, -dt_pocket - 0.01], [dt_lip_base, -dt_pocket - 0.01],
                     [dt_lip_base, 0],
                     [dt_lip_top/2, dt_lip_h], [-dt_lip_top/2, dt_lip_h],
                     [-dt_lip_base, 0]]);
}
