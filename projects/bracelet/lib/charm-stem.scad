// charm-stem — the U-PIN mount: a charm on its own STEM, the stem held in the
// bar by a U-PIN slid in along the band, the U-pin held in by the NEXT bar.
//
// Added 2026-09-28 as the alternative to the H-pin (lib/charm-pin.scad), which
// held well in a charm but kept pulling out of the bar. Nothing here springs
// in the bar at all, so there is nothing there to pull out.
//
//   * The STEM is the H-pin's upper half, unchanged — the same legs, crossbar
//     and hooks, so every charm's holes fit it as they are. Its lower legs
//     have NO hooks: they are straight stubs in a SNUG slot. Below the
//     crossbar's middle hangs a thin NECK with a FOOT on it.
//   * The U-PIN's two legs run along the band through the bar, either side of
//     the neck and just over the foot. Pull the charm and the foot meets the
//     U-pin's legs, which bear on the bar's end walls.
//   * THE CHARM IS LOCKED ON ITS STEM while the stem is in a bar. Letting a
//     charm go means turning the stem's legs (the crossbar bends between
//     them, see charm-pin.scad), and turning them swings their lower ends IN
//     — into the stub slots' walls, which hug them. Off the bar the charm
//     snaps on and off as before; on it, it does not come off at all.
//   * THE U-PIN IS LOCKED BY THE BAR BEFORE IT (lower x). It enters that
//     joint's gap, through the channel between the two knuckle clusters. The
//     bar before carries a LOCK TOOTH in that channel, so the U-pin can slide
//     out only `st_slide` — far less than the `st_travel` it needs to clear the
//     foot. Only folding that joint FORWARD to ~80 degrees (85 at the
//     tightest pitch; a wrist bends each joint ~36) swings it out of the way.
//
// Why forward, and why a tooth. Folding BACKWARD would open the low gap, but
// the charm overhangs the next bars and stops a backward fold at ~20 degrees.
// Without the tooth a forward fold frees a U-pin at ~45-55 degrees — too close
// to a wrist. With it, a U-pin pulled far enough to free the foot still hits
// the tooth at 75 degrees, and is clear at 80 (harness, wrist 130/180/200).
//
//      u ->  (across the band)                 v = 0 is the bar's top face
//
//        |<   >|          upper hooks into the charm, as on the H-pin
//   -----|=====|-----     crossbar, sunk `hp_recess`
//        |  |  |          stubs in snug slots; the neck in the middle
//        | []|[] |        the U-pin's two legs (in section), astride the neck
//        |  ===  |        the foot
//
// THE STEM PRINTS LYING FLAT like the H, `hp_t` thick. THE U-PIN PRINTS FLAT
// too, `st_ch` thick. Neither has an overhang.
//
// Everything here is named `st_*`. It includes the H-pin library for the
// stem's upper half and the charm's holes.

include <charm-pin.scad>

// ------------------------------------------------------------ the U-pin
st_neck  = 0.8;    // the stem's neck, across the band
st_lw    = 1.2;    // a U-pin leg, across the band
st_ch    = 1.2;    // the U-pin's thickness: its legs' height, and its print height
st_bight = 1.2;    // the U-pin's closed end, along the band. It sits in the gap
st_tipc  = 0.3;    // chamfer on each leg tip's outer corner, to find the bore
st_floor = 0.4;    // bar left under the WELL — two 0.2 layers, 0.2 less than
                   //   under the stub slots (`hp_floor`), so the foot gets
                   //   0.85 instead of 0.65 (under two beads). The first
                   //   layer still never sees the well.
st_foot_in = 0.05; // how far short of the legs' outer faces the foot stops
st_bore_lo = 0.2;  // a bore's floor under the U-pin's legs. Not `hp_fit`: at
                   //   0.15 it lies at z 1.40, exactly on the accent stripe's
                   //   lower plane, and the stripe came out with zero-volume
                   //   sheets. At 0.2 the legs rest on the foot, not the floor.

// ------------------------------------------------------------ the lock
st_tooth   = 2.0;  // the lock tooth, standing out of the bar before's face
st_tooth_u = 2.3;  // half its width — 0.2 into the knuckle lugs either side
st_chan    = 2.1;  // half the channel between the knuckle clusters. Set by
                   //   bracelet.scad's `row_pitch`/`body`, asserted there.

// ------------------------------------------------------------ derived
st_ci   = st_neck/2 + hp_fit;          // 0.55 — a U-pin leg's inner face
st_co   = st_ci + st_lw;               // 1.75 — and its outer face
st_well = st_co + hp_fit;              // 1.90 — the well, and a bore's outer wall
st_foot = st_co - st_foot_in;          // 1.70 — the foot's half width

st_v_cl_hi = hp_cb_bot - hp_vfit;      // -1.45 — a U-pin leg's top
st_v_cl_lo = st_v_cl_hi - st_ch;       // -2.65 — and its bottom
st_v_ft    = st_v_cl_lo - hp_vfit;     // -2.80 — the foot's top
st_v_wf    = st_floor - hp_bar;        // -3.80 — the well's floor
st_v_fb    = st_v_wf + hp_fit;         // -3.65 — the foot's bottom
st_foot_h  = st_v_ft - st_v_fb;        //  0.85

// Along the band: the stem is `hp_t` thick about the bar's centre, so its foot
// ends at +-hp_t/2. The U-pin's legs run from the bar's -x face to its +x face
// (`body` long), so the tips are flush with the far face, where a toothpick can
// push them. Pulled out along -x, the foot is free once the tips pass -hp_t/2.
function st_travel(body) = body/2 + hp_t/2;          // 4.75 at a 6.0 bar
// How far a seated U-pin can slide out before its bight meets the tooth, in a
// gap `gap` wide (the bars' faces, flat).
function st_slide(gap) = gap - st_tooth - st_bight;  // 2.51 at wrist 130 (gap 5.71)

assert(st_foot_h >= 0.8, str("the foot is ", st_foot_h, " — under two beads, and it holds the charm"));
assert(st_floor >= 0.4, "under two layers of bar beneath the well");
assert(st_neck >= 0.8, "the neck is under two beads");
assert(st_foot - st_neck/2 >= 1.0, "the foot barely reaches under the U-pin's legs");
assert(st_well < hp_ui_g - hp_fit - 1.2,
       str("under 1.2 of bar between the well and a stub slot: ",
           hp_ui_g - hp_fit - st_well));

// The crossbar is the charm's spring, as on the H — but the neck now fixes its
// middle `st_neck` (+ two fillets), so it bends over a shorter length. The
// charm goes on ONCE (it is locked there after), so this is a one-off bend,
// like the H going into the bar: ABS took 8.0 % of that.
st_cb_free   = hp_cb_len - st_neck - 2*hp_fillet;
st_strain_up = hp_turn_up * hp_cb_h / st_cb_free;
assert(st_strain_up <= 0.065,
       str("the crossbar bends to ", 100*st_strain_up,
           "% when the charm goes on — past the 6.5% allowed for a one-off bend"));

// ------------------------------------------------------------ the stem
// One leg, the +u one, in (u, v): the H-pin's leg with the lower hook cut off.
function st_leg_pts() = [
    [hp_ui_g,         hp_v_end],
    [hp_uo,           hp_v_end],
    [hp_uo,           hp_v_top],
    [hp_ui_g,         hp_v_top],
    [hp_ui_g - hp_hook_up, hp_v_ut + hp_tip_up],
    [hp_ui_g - hp_hook_up, hp_v_ut],
    [hp_ui_g,         hp_v_uc],
];

module st_stem_raw_2d() union() {
    polygon(st_leg_pts());
    mirror([1, 0]) polygon(st_leg_pts());
    translate([-hp_ui_g - 0.3, hp_cb_bot]) square([2*hp_ui_g + 0.6, hp_cb_h]);
    translate([-st_neck/2, st_v_ft - 0.01]) square([st_neck, hp_cb_bot - st_v_ft + 0.02]);
    translate([-st_foot, st_v_fb]) square([2*st_foot, st_foot_h]);
}

// Fillet only the inside corners where the crossbar meets the legs and the
// neck, and where the neck meets the foot (see hp_pin_2d on why only those).
module st_stem_2d() union() {
    st_stem_raw_2d();
    intersection() {
        offset(r = -hp_fillet) offset(r = hp_fillet) st_stem_raw_2d();
        union() {
            translate([-hp_ui_g, hp_cb_bot - 2*hp_fillet])
                square([2*hp_ui_g, hp_cb_h + 4*hp_fillet]);
            translate([-st_foot, st_v_ft - 0.05]) square([2*st_foot, 2*hp_fillet + 0.05]);
        }
    }
}

// The stem, ASSEMBLED: z = 0 is the bar's top face.
module charm_stem() hp_stand(hp_t) st_stem_2d();

// ------------------------------------------------------------ the U-pin
// In (x, u): x along the band, from the bar's centre. The bight lies against
// the bar's -x face, the legs run to its +x face.
module st_upin_2d(body) {
    translate([-body/2 - st_bight, -st_co]) square([st_bight, 2*st_co]);
    for (s = [-1, 1]) mirror([0, s < 0 ? 1 : 0])
        polygon([[-body/2 - 0.01, st_ci], [body/2, st_ci],
                 [body/2, st_co - st_tipc], [body/2 - st_tipc, st_co],
                 [-body/2 - 0.01, st_co]]);
}

// The U-pin, ASSEMBLED in a bar `body` long, z = 0 the bar's top face.
module charm_upin(body)
    translate([0, 0, st_v_cl_lo]) linear_extrude(st_ch) st_upin_2d(body);

// ------------------------------------------------------------ the cutters
// The stem's pocket, cut down from z = 0, in a bar `body` long:
//   * the crossbar's slot, whose floor is the stop the stem sits on;
//   * a SNUG slot for each stub — `hp_fit` all round, no room to turn;
//   * the WELL in the middle, for the neck, the foot and the U-pin's legs;
//   * two BORES through both end walls, one per U-pin leg.
module charm_stem_pocket(body) {
    hp_stand(hp_slot_x) union() {
        for (s = [-1, 1]) mirror([s < 0 ? 1 : 0, 0]) {
            translate([hp_ui_g - hp_fit, hp_v_fl])
                square([hp_uo - hp_ui_g + 2*hp_fit, 1 - hp_v_fl]);
            // room for the fillet under the crossbar, inside each stub. It
            // is at the pivot's height, so it frees no turn to speak of.
            translate([hp_ui_g - hp_fillet - hp_fit, hp_cb_bot - hp_fillet - hp_fit])
                square([hp_fillet + hp_fit + 0.01, hp_fillet + hp_fit + 0.01]);
        }
        translate([-hp_uo - hp_fit, hp_cb_bot]) square([2*(hp_uo + hp_fit), 1 - hp_cb_bot]);
        translate([-st_well, st_v_wf]) square([2*st_well, 1 - st_v_wf]);
    }
    // the bores, carried 1 mm past both faces
    for (s = [-1, 1])
        translate([-body/2 - 1, s > 0 ? st_ci - hp_fit : -st_well, st_v_cl_lo - st_bore_lo])
            cube([body + 2, st_well - st_ci + hp_fit, st_ch + hp_fit + st_bore_lo]);
}

// The lock tooth, on the bar before a station: in that bar's frame, standing
// out of its +x face (at x = body/2) toward the station, the bar's full height.
module charm_stem_tooth(body, thick)
    translate([body/2 - 0.5, -st_tooth_u, 0]) cube([st_tooth + 0.5, 2*st_tooth_u, thick]);
