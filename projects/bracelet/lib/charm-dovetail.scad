// charm-dovetail — how a charm hangs on the bracelet: the DOVETAIL H-PIN.
//
// The pin is two proven halves fused at a neck:
//
//   * its BOTTOM is a DOVETAIL, 16 mm long, running ACROSS the band. It slides
//     into a dovetail groove through a station bar, from the band's edge, and
//     CLICKS: a LIP on a spring leaf in the groove's floor drops into a PIT
//     under the pin;
//   * its TOP is the H-PIN's upper half (lib/charm-pin.scad) — the crossbar and
//     the two hooked legs, exactly, so every charm's two holes fit it
//     unchanged. The crossbar is still the spring, and it runs in a shallow
//     CHANNEL across the bar top, sunk `hp_recess` like the H-pin's.
//
// PUT THE CHARM ON THE PIN FIRST, in your hand: press it down over the legs
// until it snaps, as with the H-pin. Then push pin and charm into the bar from
// the band's edge until the pin clicks. Push the pin out from the other edge
// with a toothpick to take the charm off, then pull the charm off the pin.
//
// IN THE BAR THE CHARM CANNOT COME OFF. The legs let go of a charm by turning
// about the crossbar, and that swings their feet down past the channel's
// floor (asserted with `dt_leg_foot`). With the pin in the bar they cannot.
//
// THE LEAF IS THE SPRING of the click. Its lip rides the pin's underside for
// the last 3 mm going in, dipping `dt_ride` below the band's underside — so
// push the pin in with the band in your hand, not flat on a table. At rest it
// is still bent `dt_preload`, pressing the pin UP against the groove's flanks,
// so the pin does not rattle in the bar. On the wrist the skin holds the leaf
// up: the pin cannot be pushed out while it is worn.
//
// THE PIN PRINTS ON ITS SIDE, its H flat on the bed as the H-pin printed, so
// the crossbar still flexes in the bed plane, along its perimeters. The
// dovetail lies on its foot's side beside it; its flank leans out at 45.
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
//      bar    |___|  <- crossbar, in the channel         ||       <- neck
//              |_|   <- neck             ________/________\_______ dovetail
//             /___\  <- dovetail          lip on the leaf ^
//             |___|
//          ==/\=====  lip on the leaf

include <charm-pin.scad>

// --------------------------------------------------------------- the channel
dt_ch_w    = hp_slot_x;    // the channel's width along the band: the H's
                           //   slots in every charm, 0.15 round its 3.5
dt_ch_d    = 1.75;         // the channel's floor under the bar top — and the
                           //   dovetail's waist. `hp_cb_bot` is -1.30

// ----------------------------------------------------- the dovetail (x, z)
dt_bar     = 4.2;    // the bar's thickness == the band's `thick`, asserted there
dt_floor   = 1.0;    // bar under the groove — and the leaf's thickness: 5
                     //   layers. The leaf's stiffness goes as its cube
dt_w_lo    = 1.0;    // the waist's half-width: the neck and the groove's mouth
dt_a_lo    = 45;     // the flanks, degrees from vertical: a ceiling in the bar,
                     //   an overhang on the pin as it prints on its side
dt_foot    = hp_t/2; // the foot's half-width — the H's, so both stand on the
                     //   bed side by side when the pin prints on its side
dt_side    = 0.2;    // groove to foot, on the foot's vertical sides
dt_gv      = 0.15;   // the pin's bottom over the groove's floor, UP
dt_mouth   = 0.15;   // 45-degree chamfer at the groove's mouth
dt_neck_y  = 0.8;    // the neck, along y: the crossbar's middle is fused to
                     //   the dovetail over this much, which stiffens the
                     //   spring (see `dt_strain_up`). It carries every pull,
                     //   so two beads: 0.6 printed as a single wide line

// ------------------------------------------------- the pin's length and click
dt_len     = 16.0;   // the pin, across the band: the band's width less 0.1
                     //   each end, so it sits flush (asserted in bracelet.scad)
dt_lead    = 0.4;    // 45-degree chamfer under each end: rides onto the lip
dt_y_lip   = -5.0;   // the lip, and the pit over it
dt_lip_h   = 0.6;    // the lip over the groove's floor, unbent
dt_lip_top = 0.3;    // its flat crest; its flanks are 45 degrees
dt_pit     = 0.35;   // the pit's depth into the pin's underside. The lip
                     //   has to bend `dt_pit` more to leave it
dt_pit_c   = 0.05;   // the pit's flanks clear of the lip's, so the lip's
                     //   crest is what bears
dt_slot    = 0.5;    // the slots round the leaf, through the floor: the
                     //   first layer needs 0.5 to keep them open
dt_leaf_l  = 6.5;    // the leaf, root to tip (the tip is at -y)

// ------------------------------------------------------------------ derived
dt_hf     = (dt_foot - dt_w_lo) / tan(dt_a_lo);         // 0.75 flanks' height
dt_fl_top = dt_floor - dt_bar;                          // -3.20 groove floor
dt_bot    = dt_fl_top + dt_gv;                          // -3.05 pin's bottom, UP
dt_waist  = -dt_ch_d;                                   // -1.75
dt_foot_h = dt_waist - dt_hf - dt_bot;                  // 0.55 foot's straight sides
dt_g_w    = dt_foot + dt_side;                          // 1.95 groove's foot, half
dt_g_fz   = dt_waist - (dt_g_w - dt_w_lo) / tan(dt_a_lo);   // -2.70 where its flank starts
dt_leaf_w = dt_g_w - dt_slot;                           // 1.45 leaf, half-width
dt_tip    = dt_y_lip - (dt_lip_top/2 + dt_lip_h) - 0.15;   // -5.90 leaf's tip
dt_root   = dt_tip + dt_leaf_l;                         // 0.60 leaf's root
dt_preload = dt_lip_h - dt_gv - dt_pit;                 // 0.10 leaf bent at rest
dt_ride   = dt_lip_h - dt_gv;                           // 0.45 bent under the pin

// The leaf is a cantilever loaded near its tip: strain at the root is
// 3 * t * d / (2 a^2), a = root to lip.
dt_leaf_a = dt_root - dt_y_lip;
dt_strain = 3 * dt_floor * dt_ride / (2 * dt_leaf_a * dt_leaf_a);

// The H's crossbar bends in an arc between its legs. The neck holds
// `dt_neck_y` of its middle straight, so the rest bends that much harder:
// strain (and grip) go up by cb_len / (cb_len - neck).
dt_stiffen   = hp_cb_len / (hp_cb_len - dt_neck_y);
dt_strain_up = hp_strain_up * dt_stiffen;

// How far a leg's outer foot swings down as the charm lets go: the leg turns
// `hp_turn_up` about the crossbar's end, and that end drops with the arc.
dt_arm       = hp_cb_len/2 - dt_neck_y/2;
dt_end_drop  = hp_turn_up * dt_arm / 2;
function dt_rot(p, c, a) = c + [(p - c)[0]*cos(a) + (p - c)[1]*sin(a),
                               -(p - c)[0]*sin(a) + (p - c)[1]*cos(a)];
dt_leg_foot  = dt_rot([hp_uo, hp_cb_bot], [hp_ui_g, hp_pivot],
                      hp_turn_up * 180 / PI)[1] - dt_end_drop;

assert(hp_cb_bot - dt_waist >= 0.3 + dt_gv,
       "under 0.3 mm of channel under the crossbar with the pin sitting low");
assert(dt_foot_h >= 0.5,
       str("the dovetail's foot is ", dt_foot_h, " straight — the pin stands on it, on its side, and needs a bead's width"));
assert(dt_a_lo <= 45, "the flanks: 45 degrees at most");
assert(dt_preload > 0, "the leaf does not press the pin up at rest — it rattles");
assert(dt_pit >= 0.3, "the lip sits too shallow in the pit to hold");
assert(dt_strain <= 0.025,
       str("the leaf bends to ", 100*dt_strain, "% as the pin goes in — past 2.5% in PLA"));
assert(dt_strain_up <= 0.056,
       str("the crossbar bends to ", 100*dt_strain_up, "% every time a charm goes on"));
assert(dt_leg_foot < dt_waist - 0.2,
       str("a leg's foot swings only to ", dt_leg_foot, " as a charm lets go — the channel's floor at ",
           dt_waist, " would not stop it, so the charm could come off in the bar"));
assert(dt_tip - dt_slot >= -dt_len/2 + dt_lead + 0.5,
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
        translate([0, s*dt_y_lip, dt_bot]) rotate([90, 0, 90])
            linear_extrude(2*dt_foot + 1, center = true)
                polygon([[-(dt_lip_top/2 + dt_pit_c + dt_pit), -0.01],
                         [  dt_lip_top/2 + dt_pit_c + dt_pit,  -0.01],
                         [  dt_lip_top/2 + dt_pit_c, dt_pit],
                         [-(dt_lip_top/2 + dt_pit_c), dt_pit]]);
    }
}

// The H's upper half: the H-pin's own outline from the crossbar's bottom up.
// Its lower legs and hooks are all below that line, so they go.
module dt_pin_up() hp_stand(hp_t) intersection() {
    hp_pin_2d();
    translate([-20, hp_cb_bot]) square([40, 20]);
}

// The neck: the waist carried up into the crossbar's middle.
module dt_neck() translate([-dt_w_lo, -dt_neck_y/2, dt_waist - 0.01])
    cube([2*dt_w_lo, dt_neck_y, hp_cb_bot - dt_waist + 0.02]);

// The pin, ASSEMBLED and UP. models/pin lays it on its side to print.
module dt_pin() union() { dt_pin_lo(); dt_neck(); dt_pin_up(); }

// ----------------------------------------------------------------- the bar
// The groove's outline, one side, in (x, z): the foot, the flank the pin's
// bears on, the mouth's chamfer at the channel's floor, and the channel.
function dt_groove_pts() = [
    [0,       dt_fl_top],
    [dt_g_w,  dt_fl_top],
    [dt_g_w,  dt_g_fz],
    [dt_w_lo + dt_mouth*tan(dt_a_lo),            dt_waist - dt_mouth],
    [dt_w_lo + dt_mouth*tan(dt_a_lo) + dt_mouth, dt_waist],
    [dt_ch_w/2, dt_waist],
    [dt_ch_w/2, 1],
    [0,       1],
];

// What a station cuts from its bar, z = 0 at the bar's top: the channel and
// the groove under it, right through the bar across the band, and the slots
// that free the leaf.
module dt_bar_cut() {
    rotate([90, 0, 0]) linear_extrude(40, center = true) dt_sym2d(dt_groove_pts());
    translate([0, 0, -dt_bar - 1]) {
        for (s = [-1, 1])        // along the leaf's sides
            translate([s > 0 ? dt_leaf_w : -dt_g_w, dt_tip - dt_slot, 0])
                cube([dt_slot, dt_root - (dt_tip - dt_slot), dt_floor + 1.01]);
        translate([-dt_g_w, dt_tip - dt_slot, 0])     // across its tip
            cube([2*dt_g_w, dt_slot, dt_floor + 1.01]);
    }
}

// What a station adds to its bar once cut: the lip on the leaf.
module dt_bar_add() {
    translate([0, dt_y_lip, dt_fl_top]) rotate([90, 0, 90])
        linear_extrude(2*dt_leaf_w, center = true)
            polygon([[-(dt_lip_top/2 + dt_lip_h), -0.01], [dt_lip_top/2 + dt_lip_h, -0.01],
                     [dt_lip_top/2, dt_lip_h], [-dt_lip_top/2, dt_lip_h]]);
}
