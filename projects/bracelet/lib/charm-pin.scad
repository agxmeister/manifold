// charm-pin — how a charm hangs on the bracelet: the H-PIN mount.
//
// A flat H. Two upright LEGS joined by a CROSSBAR, a small HOOK on every leg.
// The lower half pushes down into a pocket in a bar and its hooks snap under
// shoulders at the foot of the pocket; the charm pushes down over the upper
// half and the upper hooks snap into it. The crossbar is sunk just below the
// bar's top face, so the charm lands flat on the bar.
//
// This is the only mount. A fused ball pin and a loose double-ended screw came
// before it, both printed and both worked; they were removed on 2026-09-24,
// with their charms, once this one proved the best. Git history has them.
//
// The pin, the pocket in the bar and the holes in the charm all live here, so
// the three can only change together. The file draws nothing — variables,
// functions and modules only — so every model `include`s it.
//
// Everything here is named `hp_*`. The hinge already owns `pin_*`.
//
//      u ->  (across the band, assembled)          v = 0 is the bar's top face
//
//        |<   >|        upper hooks point IN, into the charm's two holes
//   -----|=====|-----   v = 0: bar top / charm seat; crossbar `hp_recess` below
//        |>   <|        lower hooks point OUT, under the pocket's shoulders
//
// THE TWO HALVES ARE THE SAME LENGTH: the upper legs reach exactly as far
// above the seat as the lower ones reach below it. The crossbar is off-centre
// (it has to sit in the bar), so the H is not symmetric, but its extents are.
//
// THE H PRINTS LYING FLAT, on its face, `hp_t` thick. Its hooks are corners of
// a 2D outline, so the pin has no overhang anywhere and its springs flex in
// the bed plane, along the perimeters.
//
// NEITHER HALF'S LEGS ARE THE SPRING — BOTH ARE TOO SHORT. A 3.45 mm leg bent
// 0.4 mm strains ~6-15 %. So the legs TURN about the crossbar's middle, and the
// CROSSBAR bends in an arc between them (`hp_strain_cb`). It is the long thin
// member of the part and carries none of the pull, which goes down the legs.
//
// WHY THE UPPER HOOKS POINT INWARD. Turning a leg moves its two ends opposite
// ways. Going into the bar the lower hooks are pushed IN, the upper ends swing
// OUT, and they are free — no charm yet. Going into the charm the upper hooks
// have to move one way and the lower ends then move the other, while the
// lower hooks are already under their shoulders. With every hook pointing out,
// that second move would drive the lower hooks deeper, straight into the
// shoulders above them: it jams. Pointing the upper hooks IN, fitting the
// charm swings the upper ends OUT and the lower ends IN — the lower hooks back
// off their shoulders a little and spring home once the charm has snapped.
//
// THE TWO CATCHES ARE DIFFERENT ANGLES, and each is forced by how its part
// prints:
//
//   * the BAR prints upright, so the lower hooks' shoulder faces DOWN — a
//     ceiling. It descends away from the slot at 45 degrees, the material
//     closing in over the chamber like a hole's roof. 45 is a detent, but it
//     never has to be more: the lower hooks can only let go by turning the
//     legs, and while a charm is on, the charm holds the upper ends.
//   * the CHARM prints SEAT DOWN, so the upper hooks' shoulder is a FLOOR and
//     may be any angle. `hp_catch_up` is steeper than 45 on purpose: that is
//     what makes the charm hold. It is the one tuning number of this mount.
//     What goes the other way is the far end of each hole, now a ceiling:
//     it is roofed with a 45-degree gable.

hp_t      = 2.8;    // the H's thickness: its print height, and its extent
                    //   ALONG the band once assembled
hp_leg_w  = 1.0;    // a leg, across
hp_s      = 4.6;    // a leg's centre off the H's axis
hp_cb_h   = 0.76;   // the crossbar, top to bottom — THE spring. Meant to be
                    //   under the 1.2 mm wall threshold, like the clasp's leaf.
hp_recess = 0.3;    // how far the crossbar's top sits below the bar's top face
hp_fillet = 0.3;    // inside corners where the crossbar meets a leg — the
                    //   spring's roots. recess >= fillet keeps the fillets
                    //   below the charm's seat face (asserted).

hp_hook_lo = 0.70;  // how far a LOWER hook stands out from its leg
hp_hook_up = 0.75;  // how far an UPPER hook stands out — see "bigger hooks"
hp_lead   = 40;     // the LOWER hook's lead-in, degrees from vertical: steeper
                    //   = easier in. (The upper one is whatever runs from its
                    //   tip to the leg's top, `hp_lead_up`.)
hp_roof_lead = 35;  // the slope of a charm chamber's roof, from vertical
hp_under  = 1.0;    // charm left under the upper hooks' shoulders. The upper
                    //   hooks sit as LOW as this allows — see "the spring"
hp_tip    = 0.3;    // straight flat at the hook's edge, never a point
hp_catch_up = 60;   // the UPPER catch, degrees from vertical. 45 = a light
                    //   detent (the charm pulls off easily); 55 printed and
                    //   still pulled off lightly, with 0.4 mm hooks; past
                    //   ~60 the friction locks it and the charm is on for good.
hp_fit    = 0.15;   // clearance: a hook's tip to its chamber, a leg to its
                    //   slot, and the H's faces to the slots along the band
hp_vfit   = 0.15;   // vertical play between a seated hook and its shoulder
hp_gap    = 0.2;    // a leg's end to the far end of its hole

hp_bar    = 4.45;   // the bar's thickness == the band's `thick`, asserted there
hp_floor  = 0.8;    // bar left under the pocket — it never reaches the first
                    //   layer
hp_wall   = 1.2;    // charm wall around its two holes

// ------------------------------------------------------------------ derived
hp_uo     = hp_s + hp_leg_w/2;                  // 5.00 — leg's outer face
hp_ui     = hp_s - hp_leg_w/2;                  // 4.00 — leg's inner face
hp_lr     = hp_hook_lo / tan(hp_lead);          // 0.83 — lead-in rise
hp_cr     = hp_hook_up / tan(hp_catch_up);      // 0.43 — upper catch rise
hp_defl_lo = hp_hook_lo - hp_fit;               // 0.55 — how far a hook has to
hp_defl_up = hp_hook_up - hp_fit;               // 0.60 —   move to pass its wall

hp_cb_top = -hp_recess;                         // -0.30
hp_cb_bot = hp_cb_top - hp_cb_h;                // -1.06
hp_v_fl   = hp_floor - hp_bar;                  // -3.65 — the pocket's floor
hp_v_end  = hp_v_fl + hp_gap;                   // -3.45 — lower leg's end
hp_v_lt   = hp_v_end + hp_lr + hp_tip;          // -2.32 — lower hook's tip top
hp_v_lc   = hp_v_lt + hp_hook_lo;               // -1.62 — lower catch meets leg
hp_v_top  = -hp_v_end;                          //  3.45 — AS SHORT AS THE BOTTOM
hp_v_uc   = hp_under + hp_vfit;                 //  1.15 — upper catch meets leg
hp_v_ut   = hp_v_uc + hp_cr;                    //  1.58 — upper hook's tip bottom
hp_lr_up  = hp_v_top - hp_v_ut - hp_tip;        //  1.57 — its lead-in, tip to leg top
hp_lead_up = atan(hp_hook_up / hp_lr_up);       //  26 deg from vertical

// The spring. The legs turn about the crossbar's middle and the crossbar bends
// in a pure arc, strain = angle * depth / length. Going into the bar the lever
// is the short one (pivot -> lower hook), so that insertion sets the strain;
// going into the charm the lever is longer and the turn smaller.
//
// THE LEVERS DECIDE HOW FIRMLY EACH HALF HOLDS. A hook feels the crossbar's
// moment over its lever, and the turn is its travel over the same lever, so
// its force goes as cb_h^3 / lever^2. The crossbar has to stay in the bar, so
// the pivot is below the seat and the charm's lever is always the longer one.
// Until 2026-09-23 the upper hooks sat at the top of their legs, on a 3.21
// lever against the bar's 1.81, and held with a third of the bar's force: the
// charm felt loose on a real print. They now sit as low as `hp_under` allows,
// with a long gentle lead-in above them up to the leg's top (the leg is still
// as long as the bottom one), which cuts the lever to 2.44.
//
// BIGGER HOOKS, 2026-09-25. That retune printed, and a heart still came off
// with a light pull. The retune had made the SPRING ~2.5x firmer on paper, so
// the spring was not what let go: the catches were. A 0.4 mm catch is about
// one bead, and the printer rounds that much of it away, so the hook rolls off
// a rounded edge instead of sitting behind a 55-degree face. The hooks now
// overlap 0.60 (charm) and 0.55 (bar), the charm's catch is 60 degrees, and
// the rest follows from keeping the three rules below:
//   * the bar's hooks had to grow WITH the charm's, or `hp_keep` goes negative
//     and the pin leaves the bar with the charm;
//   * bigger bar hooks mean a bigger turn going in, so the crossbar is thinner
//     (0.76) and longer (the legs 0.1 further out) to stay under 2.9 %;
//   * the upper legs TAPER on the outside above the hook (`hp_taper`), so the
//     turning leg end needs no more room than before and the charm's holes do
//     not grow (`hp_c_out` 5.79 -> 5.76). Every charm keeps its fit.
//
// THE CHARM'S LEVER MUST STAY THE LONGER ONE. Pulling the charm off turns the
// legs the way that also lets the lower hooks go. The longer lever turns
// less for the same hook travel, so the charm lets go while the lower hooks
// still overlap their shoulders by `hp_keep` — and the pin stays in the bar.
hp_pivot  = (hp_cb_top + hp_cb_bot)/2;
hp_arm_lo = hp_pivot - (hp_v_end + hp_lr + hp_tip/2);
hp_arm_up = (hp_v_ut + hp_tip/2) - hp_pivot;
hp_turn_lo = hp_defl_lo / hp_arm_lo;
hp_turn_up = hp_defl_up / hp_arm_up;
hp_cb_len = 2*hp_ui;
hp_strain_cb = max(hp_turn_lo, hp_turn_up) * hp_cb_h / hp_cb_len;
// A turning leg's END swings further than its hook, so each hole leaves room
// on the side the end swings to: INSIDE the lower legs (bar), OUTSIDE the
// upper legs (charm). Above the upper hook the leg's outer face leans in by
// exactly the turn, so every point of it swings out no further than the face
// does at the hook's tip — that is all the room the charm's hole has to give.
hp_taper  = hp_turn_up * (hp_v_top - hp_v_ut);            // 0.46
hp_room_lo = hp_turn_lo * (hp_pivot - hp_v_end) + 0.1;   // 0.95
hp_room_up = hp_turn_up * (hp_v_ut - hp_pivot) + 0.1;    // 0.66
hp_keep   = hp_defl_lo - hp_turn_up * hp_arm_lo;          // 0.11

hp_slot_x = hp_t + 2*hp_fit;                    // 3.10 — every slot, along the band
hp_out    = hp_uo + hp_hook_lo + hp_fit;        // 5.95 — a bar chamber's outer wall
hp_c_out  = hp_uo + hp_room_up;                 // a charm hole's outer wall
hp_c_in   = hp_ui - hp_hook_up - hp_fit;        // 3.20 — a charm chamber's inner wall
hp_roof   = hp_v_top + hp_gap;                  // 3.65 — a charm hole's eaves
hp_apex   = hp_roof + hp_slot_x/2;              // 5.20 — and the gable's ridge
hp_boss_x = hp_slot_x + 2*hp_wall;              // 5.50
hp_boss_u = 2*hp_c_out + 2*hp_wall;

assert(hp_lead < 45, "the hook's lead-in is flatter than its catch — it would hold going IN");
assert(hp_catch_up >= 45 && hp_catch_up <= 60,
       str("hp_catch_up = ", hp_catch_up, ": under 45 the charm falls off, past 60 friction locks it on"));
assert(hp_v_lc < hp_cb_bot - 0.3,
       str("the lower hook runs into the crossbar: catch top ", hp_v_lc,
           ", crossbar bottom ", hp_cb_bot));
assert(hp_under >= 1.0,
       str("only ", hp_under, " mm of charm under the upper hooks' shoulders"));
assert(hp_lead_up < hp_lead + 1e-6, "the upper hook's lead-in is steeper to push past than the lower one's");
assert(hp_keep >= 0.1,
       str("the lower hooks hold only ", hp_keep, " mm when the charm lets go —",
           " the pin would come out of the bar with the charm"));
assert(hp_recess >= hp_fillet,
       "the crossbar's fillets stand above the bar's top face and into the charm");
assert(hp_strain_cb <= 0.029,
       str("the crossbar bends to ", 100*hp_strain_cb,
           "% — past the 2.9% this project's flexures run at"));
assert(hp_room_lo < hp_ui - hp_fillet - 0.8,
       "the legs' inward room eats the bar between the two leg slots");
assert(hp_c_in > hp_cb_len/2 - hp_ui + 2.0, "the charm's two chambers meet in the middle");
assert(min(hp_defl_lo, hp_defl_up) >= 0.5,
       "the hooks overlap their shoulders by less than the printer rounds off");
assert(hp_leg_w - hp_taper >= 0.5, "the upper legs taper to a sliver at the top");

// ----------------------------------------------------------------- the pin
// One leg, the one at +u, in (u, v): lower hook OUT, upper hook IN. The left
// leg is its mirror.
function hp_leg_pts() = [
    [hp_ui,           hp_v_end],
    [hp_uo,           hp_v_end],
    [hp_uo + hp_hook_lo, hp_v_end + hp_lr],          // lower lead-in
    [hp_uo + hp_hook_lo, hp_v_lt],                   // tip flat
    [hp_uo,           hp_v_lc],                      // 45-degree catch
    [hp_uo,           hp_v_ut],
    [hp_uo - hp_taper, hp_v_top],                    // the taper, see hp_taper
    [hp_ui,           hp_v_top],
    [hp_ui - hp_hook_up, hp_v_ut + hp_tip],          // upper lead-in, to the top
    [hp_ui - hp_hook_up, hp_v_ut],                   // tip flat
    [hp_ui,           hp_v_uc],                      // `hp_catch_up` catch
];

module hp_pin_raw_2d() union() {
    polygon(hp_leg_pts());
    mirror([1, 0]) polygon(hp_leg_pts());
    translate([-hp_ui - 0.3, hp_cb_bot]) square([2*hp_ui + 0.6, hp_cb_h]);
}

// The H's outline, in (u, v). The four inside corners where the crossbar
// meets the legs are filleted — they are the spring's roots — and ONLY those:
// a closing pass over the whole outline would also fill the root of every
// catch by a few hundredths and eat the hooks' clearance there.
module hp_pin_2d() union() {
    hp_pin_raw_2d();
    intersection() {
        offset(r = -hp_fillet) offset(r = hp_fillet) hp_pin_raw_2d();
        translate([-hp_ui, hp_cb_bot - 2*hp_fillet])
            square([2*hp_ui, hp_cb_h + 4*hp_fillet]);
    }
}

// An (u, v) outline stood up in 3D: x = along the band (the extrusion,
// centred), y = u, z = v.
module hp_stand(w) rotate([90, 0, 90]) linear_extrude(w, center = true) children();

// The pin, ASSEMBLED: z = 0 is the bar's top face. models/pin lays
// it flat for printing.
module charm_h_pin() hp_stand(hp_t) hp_pin_2d();

// ------------------------------------------------------------- the cutters
// The bar's pocket, one side, in (u, v). The shoulder over the chamber
// descends OUTWARD at 45 degrees — `hp_vfit` above the hook's catch — so as the
// bar prints upward the material closes in over the chamber and there is no
// ceiling. The mouth is chamfered `hp_fit` outward so the hooks find it.
function hp_bar_pocket_pts() = [
    [hp_ui - hp_room_lo, hp_v_fl],
    [hp_out,             hp_v_fl],
    [hp_out,             hp_v_lt + hp_vfit - hp_fit],
    [hp_uo + hp_fit,     hp_v_lc + hp_vfit - hp_fit],
    [hp_uo + hp_fit,     -0.4],
    [hp_uo + 2*hp_fit,   0],
    [hp_uo + 2*hp_fit,   1],
    [hp_ui - hp_room_lo, 1],
];

// The pocket, cut DOWN from z = 0 (a bar's top face): two leg slots with a
// chamber at the foot of each, joined across the top by the crossbar's slot.
// The crossbar's slot floor is the stop the H is pushed down onto.
module charm_h_pocket() hp_stand(hp_slot_x) union() {
    polygon(hp_bar_pocket_pts());
    mirror([1, 0]) polygon(hp_bar_pocket_pts());
    translate([-hp_uo, hp_cb_bot]) square([2*hp_uo, 1 - hp_cb_bot]);
}

// A charm's hole, one side, in the charm's ASSEMBLED frame — which is also
// its PRINT frame, since it prints seat down: v = 0 is the seat, the hole runs
// up. The chamber is on the INSIDE (the upper hooks point in): its floor is the
// shoulder, `hp_vfit` under the catch and at the catch's own angle; its roof
// follows the hook's lead-in down and inward, the material growing out from
// the chamber's inner wall at `hp_roof_lead` from vertical. Over the leg the hole
// stops at flat eaves, and `charm_h_holes` puts a 45-degree gable on them.
function hp_c_sh(u) = hp_v_uc + (hp_ui - u) * hp_cr / hp_hook_up - hp_vfit;
function hp_c_rf(u) = hp_roof - (hp_ui - u) / tan(hp_roof_lead);
function hp_charm_hole_pts() = [
    [hp_ui - hp_fit, -1],
    [hp_c_out,       -1],
    [hp_c_out,       hp_roof],
    [hp_ui - hp_fit, hp_roof],
    [hp_ui - hp_fit, hp_c_rf(hp_ui - hp_fit)],
    [hp_c_in,        hp_c_rf(hp_c_in)],
    [hp_c_in,        hp_c_sh(hp_c_in)],
    [hp_ui - hp_fit, hp_c_sh(hp_ui - hp_fit)],
];
assert(hp_c_rf(hp_ui - hp_fit) - (hp_v_ut + hp_tip + (hp_hook_up - hp_fit) * hp_lr_up / hp_hook_up)
       >= hp_gap, "the charm's chamber roof comes down onto the hook's lead-in");
assert(hp_c_rf(hp_c_in) - hp_c_sh(hp_c_in) >= 0.2,
       "the charm's chamber pinches shut at its inner wall");

// The two holes, cut UP from z = 0 (the charm's seat face).
module charm_h_holes() {
    hp_stand(hp_slot_x) {
        polygon(hp_charm_hole_pts());
        mirror([1, 0]) polygon(hp_charm_hole_pts());
    }
    // the gables: 45-degree roofs over each leg's end, running along u
    for (s = [-1, 1])
        translate([0, s*(hp_ui - hp_fit + hp_c_out)/2, 0])
            rotate([90, 0, 0])
                linear_extrude(hp_c_out - (hp_ui - hp_fit), center = true)
                    // walls carried a millimetre down into the hole, so the
                    // gable meets them square instead of leaving a ledge
                    polygon([[-hp_slot_x/2, hp_roof - 1], [hp_slot_x/2, hp_roof - 1],
                             [ hp_slot_x/2, hp_roof], [0, hp_apex],
                             [-hp_slot_x/2, hp_roof]]);
}

// The least a charm must be around those holes, in plan: x along the band,
// y = u. `hp_apex + hp_wall` is the least it must be tall over them.
module charm_h_boss_2d()
    offset(r = hp_wall) square([hp_slot_x, 2*hp_c_out], center = true);
