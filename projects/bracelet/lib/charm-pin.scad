// charm-pin — how a charm hangs on the bracelet: the H-PIN mount.
//
// SINCE 2026-09-30 THE PIN KEEPS ONLY THE H's UPPER HALF: its lower legs are
// replaced by a dovetail that slides into the bar (lib/charm-dovetail.scad,
// which includes this file). Everything here about the UPPER half — the
// crossbar, the upper legs and hooks, and every charm's two holes — is still
// live. The bar's pocket (`charm_h_pocket`), the lower hooks and their
// asserts describe the H-pin as it was; the band no longer uses them.
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
//     ceiling. It descends away from the slot, the material closing in over
//     the chamber like a hole's roof. It was 45 until 2026-09-25, on the
//     belief that a seated charm holds the legs still. It does NOT: the turn
//     that frees the charm is the turn that frees the bar (see `hp_keep`),
//     and a 45-degree catch did most of the camming — the pin pulled out of
//     the bar on a real print. It was 60 until 2026-09-27 and is now 85:
//     all but flat, a 0.95 x 3.1 mm bridge anchored on the slot's two walls.
//   * the CHARM prints SEAT DOWN, so the upper hooks' shoulder is a FLOOR and
//     may be any angle. `hp_catch_up` is steep on purpose — 80 since
//     2026-09-27: that is what makes the charm hold. It is the one tuning
//     number of this mount.
//     What goes the other way is the far end of each hole, now a ceiling:
//     it is roofed with a 45-degree gable.

hp_t      = 3.5;    // the H's thickness: its print height, and its extent
                    //   ALONG the band once assembled. 2.8 until 2026-09-27;
                    //   3.5 leaves 1.1 of bar either side of the pocket, so
                    //   the bar's top chamfer is filled in at a station (see
                    //   `hp_fill_u`) — at 2.8 it was 0.99 at the rim.
hp_leg_w  = 1.0;    // the leg's original width. Since 2026-09-27 each leg is
                    //   `hp_grow` wider on its INSIDE, top to bottom, with no
                    //   step anywhere: one straight bar from `hp_ui_g` to
                    //   `hp_uo` (the user's sketch). The outer face carries
                    //   the lower hook and does not move.
hp_grow   = 0.6;    // a leg, grown INWARD, its whole length
hp_s      = 4.6;    // a leg's centre off the H's axis
hp_cb_h   = 1.0;    // the crossbar, top to bottom — THE spring. Its hold goes
                    //   as cb_h^3. 1.0 since 2026-09-27 (see "a stiff
                    //   crossbar"): at 0.65 the pin was too soft to hold.
                    //   0.76 until 2026-09-27, when the straight legs cut its
                    //   free length 8.2 -> 7.0: strain goes as depth / length,
                    //   so it came down to hold 2.9 / 3.8 %.
hp_recess = 0.3;    // how far the crossbar's top sits below the bar's top face
hp_fillet = 0.3;    // inside corners where the crossbar meets a leg — the
                    //   spring's roots. recess >= fillet keeps the fillets
                    //   below the charm's seat face (asserted).

hp_hook_lo = 1.00;  // how far a LOWER hook stands out from its leg — 0.70
                    //   until 2026-09-26, 0.85 until 2026-09-28: each time
                    //   the pin still left the bar with a pull (see "longer
                    //   bar hooks" and "bar hooks like the charm's")
hp_hook_up = 1.00;  // how far an UPPER hook stands out — 0.75, then 0.90
                    //   until 2026-09-27 (see "a stiff crossbar")
hp_lead   = 50;     // the LOWER hook's lead-in, degrees from vertical: steeper
                    //   = easier in. 44 until 2026-09-28; blunter, it rises
                    //   less and keeps the hook low on its lever. (The upper one is whatever runs from its
                    //   tip to the leg's top, `hp_lead_up`.)
hp_roof_lead = 42;  // the slope of a charm chamber's roof, from vertical —
                    //   35 until the taller upper tip came up under it
hp_under  = 1.35;   // charm left under the upper hooks' shoulders. It sets
                    //   the charm's lever — see "the spring" and "near-square
                    //   catches". 1.0, then 1.5 until 2026-09-27: the longer
                    //   hook's lead-in needs the room above it.
hp_tip_lo = 0.6;    // straight flat at the LOWER hook's edge, never a point.
                    //   0.3 until 2026-09-28 — under a bead, like the upper
                    //   tip's was: the printer rounded the catch away
hp_tip_up = 0.6;    // the same on the UPPER hook — 0.3 until 2026-09-27.
                    //   0.3 is under a bead: the slicer laid the tooth's
                    //   outer 0.3 mm as one blob of a line and rounded the
                    //   catch off. 0.8 was wanted; 0.6 is what fits, because
                    //   the tip's height comes out of the lead-in above it
                    //   (`hp_lead_up` must stay under `hp_lead`).
hp_catch_lo = 85;   // the LOWER catch, in the bar, degrees from vertical. It
                    //   prints as a CEILING: at 85 it is all but flat, a
                    //   0.95 x 3.1 mm BRIDGE between the slot's two walls.
                    //   45 until 2026-09-25, 60 until 2026-09-27.
hp_catch_up = 80;   // the UPPER catch, degrees from vertical. 45 = a light
                    //   detent; 55 and then 60 printed and the charm still
                    //   came off with a small effort (a sleeve brushing it).
                    //   On paper anything past ~68 is friction-locked; the
                    //   printer rounds the catch's edge, and that rounding
                    //   is what lets a near-square catch go at all. 80 is the
                    //   user's choice, 2026-09-27 — see "near-square catches".
hp_fit    = 0.15;   // clearance: a hook's tip to its chamber, a leg to its
                    //   slot, and the H's faces to the slots along the band
hp_vfit   = 0.15;   // vertical play between a seated hook and its shoulder
hp_gap    = 0.2;    // an upper leg's end to the far end of its charm hole
                    //   (under the lower legs it is 0.15: `hp_leg_lo`)

hp_bar    = 4.2;    // the bar's thickness == the band's `thick`, asserted there
hp_floor  = 0.6;    // bar left under the pocket — it never reaches the first
                    //   layer. It was 0.8 under a 4.45 bar; when the bar came
                    //   down to 4.2 (2026-09-25) the floor took the cut. Keep
                    //   it on a 0.2 boundary: 0.55 falls mid-layer at 0.1 mm.
hp_leg_lo = 3.45;   // how far the lower legs reach below the seat. Fixed — the
                    //   printed length — so the pin, the pocket's hooks and
                    //   every charm's holes did not move when the bar thinned
hp_wall   = 1.2;    // charm wall around its two holes
hp_mouth_v = 0.8;   // the bar pocket's mouth: a chamfer down the leg slot's
hp_mouth_u = 0.5;   //   outer wall, this deep and this wide at the top.
                    //   0.6 x 0.3 until the bar's hooks grew (2026-09-28)
                    //   and turned the legs 32 deg going in. It
                    //   was 0.4 x 0.15 until the 1.0 crossbar dropped the
                    //   pivot: going in, the leg above the pivot swings out
                    //   into the mouth's top (0.19 mm^3 in the harness, still
                    //   0.06 at the last lift the hook is fully deflected)

// ------------------------------------------------------------------ derived
hp_uo     = hp_s + hp_leg_w/2;                  // 5.10 — leg's outer face
hp_ui     = hp_s - hp_leg_w/2;                  // 4.10 — leg's inner face (the neck)
hp_lr     = hp_hook_lo / tan(hp_lead);          // 0.88 — lead-in rise
hp_ui_g   = hp_ui - hp_grow;                    // 3.50 — a leg's inner face,
                                                //   above and below the neck
hp_cr     = hp_hook_up / tan(hp_catch_up);      // 0.16 — upper catch rise
hp_defl_lo = hp_hook_lo - hp_fit;               // 0.55 — how far a hook has to
hp_defl_up = hp_hook_up - hp_fit;               // 0.75 —   move to pass its wall

hp_cb_top = -hp_recess;                         // -0.30
hp_cb_bot = hp_cb_top - hp_cb_h;                // -1.06
hp_v_fl   = hp_floor - hp_bar;                  // -3.60 — the pocket's floor
hp_v_end  = -hp_leg_lo;                         // -3.45 — lower leg's end
hp_v_lt   = hp_v_end + hp_lr + hp_tip_lo;       // -2.27 — lower hook's tip top
hp_v_lc   = hp_v_lt + hp_hook_lo / tan(hp_catch_lo);  // -2.20 — lower catch meets leg
hp_v_top  = -hp_v_end;                          //  3.45 — AS SHORT AS THE BOTTOM
hp_v_uc   = hp_under + hp_vfit;                 //  1.65 — upper catch meets leg
hp_v_ut   = hp_v_uc + hp_cr;                    //  1.81 — upper hook's tip bottom
hp_lr_up  = hp_v_top - hp_v_ut - hp_tip_up;     //  1.04 — its lead-in, tip to leg top
hp_lead_up = atan(hp_hook_up / hp_lr_up);       //  41 deg from vertical

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
hp_arm_lo = hp_pivot - (hp_v_end + hp_lr + hp_tip_lo/2);
// The upper lever runs to the tip's BOTTOM corner, the catch corner: that is
// the point that has to clear the charm's wall, and it is the tip's lowest,
// so it swings least. (To the tip's middle until 2026-09-27; with a 0.3 tip
// that was 0.15 of error, covered by the harness's 1.03 margin. With a
// taller tip it was not.) The lower lever still runs to its tip's middle:
// that tip is on the leg's outside, and turning adds to its travel there.
hp_arm_up = hp_v_ut - hp_pivot;
hp_turn_lo = hp_defl_lo / hp_arm_lo;
hp_turn_up = hp_defl_up / hp_arm_up;
hp_cb_len = 2*hp_ui_g;                          // 7.0 — between the legs' inner faces
hp_strain_cb = max(hp_turn_lo, hp_turn_up) * hp_cb_h / hp_cb_len;
hp_strain_up = hp_turn_up * hp_cb_h / hp_cb_len;   // every charm on and off
// A turning leg's END swings further than its hook, so each hole leaves room
// on the side the end swings to: INSIDE the lower legs (bar), OUTSIDE the
// upper legs (charm). Above the upper hook the leg's outer face leans in by
// exactly the turn, so every point of it swings out no further than the face
// does at the hook's tip — that is all the room the charm's hole has to give.
hp_room_lo = hp_turn_lo * (hp_pivot - hp_v_end) + 0.1;   // 1.21
hp_room_up = hp_turn_up * (hp_v_top - hp_pivot) + 0.1;    // 1.34 — at the leg's TOP
hp_keep   = hp_defl_lo - hp_turn_up * hp_arm_lo;          // 0.18

hp_slot_x = hp_t + 2*hp_fit;                    // 3.80 — every slot, along the band
hp_out    = hp_uo + hp_hook_lo + hp_fit;        // 6.10 — a bar chamber's outer wall
hp_c_out  = hp_uo + hp_room_up;                 // 6.44 — a charm hole's outer wall
hp_c_in   = hp_ui_g - hp_hook_up - hp_fit;      // 2.45 — a charm chamber's inner wall
hp_roof   = hp_v_top + hp_gap;                  // 3.65 — a charm hole's eaves
hp_apex   = hp_roof + hp_slot_x/2;              // 5.55 — and the gable's ridge
hp_boss_x = hp_slot_x + 2*hp_wall;              // 6.20
hp_boss_u = 2*hp_c_out + 2*hp_wall;

assert(hp_v_end - hp_v_fl >= hp_fit - 1e-9,
       str("the lower legs bottom out in the pocket: ", hp_v_end - hp_v_fl, " mm under them"));
assert(hp_lead <= 50, "the lower hook's lead-in is blunter than 50 — too hard to push in");
// A ceiling in the bar: up to 60 it steps in under a bead a layer; past 80
// it is a flat bridge between the slot's walls. Between the two it is neither.
assert(hp_catch_lo >= 45 && (hp_catch_lo <= 60 || hp_catch_lo >= 80) && hp_catch_lo <= 90,
       str("hp_catch_lo = ", hp_catch_lo, ": a ceiling in the bar — a 45-60 slope or an 80-90 bridge"));
assert(hp_catch_up >= 45 && hp_catch_up < 90,
       str("hp_catch_up = ", hp_catch_up, ": under 45 the charm falls off; 90 has no edge left to round"));
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
// LONGER BAR HOOKS, 2026-09-26. The bar's hooks overlap 0.70 (were 0.55),
// asked for by the user after the pin kept leaving the bar. That is what
// `hp_keep` needed — it grows from 0.11 to 0.27 mm, the bar's hooks now
// still well under their shoulders when the charm lets go — and it costs a
// bigger turn going INTO the bar: 3.7 % in the crossbar, past the 2.9 % the
// project's other flexures run at. That bend happens once per pin, when it
// is pushed in; every charm going on and off stays at `hp_strain_up`, under
// 2.9. If a crossbar cracks going in, 0.80 gives 3.4 %.
// NEAR-SQUARE CATCHES, 2026-09-27. The charms still came off the pin with a
// small effort — a sleeve brushing past was enough. The user chose catches
// close to square: `hp_catch_lo` 60 -> 85, `hp_catch_up` 60 -> 80. A pull
// then pushes a hook almost straight into its shoulder instead of camming it
// sideways, and it is the printer's rounding of the edge, not the angle, that
// lets a charm go at all — so a real print is the only test of how hard it is.
//   * The steeper upper catch rises less (0.43 -> 0.16), which would drop
//     the hooks and shorten the charm's lever: more strain per charm, less
//     `hp_keep`, and the leg tips tapered to 0.38. `hp_under` 1.0 -> 1.5
//     puts the hooks back up, and leaves more charm under them.
//   * The upper hooks are longer, 0.75 -> 0.90 (0.75 past the wall). That is
//     as far as they go: 0.95 needs the leg tips under 0.5 or the strain past
//     2.9 %. The LOWER hooks cannot grow: `hp_out` is the band's width limit
//     (`band_w/2 - hp_out >= 2.0`) and their turn sets the 3.73 % insertion
//     strain.
//   * The lower catch is a ceiling in the bar, now a 0.95 x 3.1 mm flat
//     bridge between the slot's walls, not a 60-degree stepped roof.
//   * `hp_c_out` 5.76 -> 5.91: the charms' holes are a little longer, so
//     every charm, the band and the pin must be reprinted together.
// A THICKER PIN WITH GROWN LEGS, 2026-09-27 (later). The near-square
// catches printed and were "slightly better, but not enough": the angle was
// smoothed away because the part is so small. The user sketched the fix:
//   * `hp_t` 2.8 -> 3.5, more grip along the band. The bar's top chamfer is
//     filled at a station (bracelet.scad) so 1.1 of wall reaches the rim.
//   * the LOWER legs grown 0.6 INWARD, the UPPER legs 0.5 OUTWARD — the
//     faces with no hooks on them, so no hook, `hp_out` or `hp_c_in` moved.
//     The lower growth stops `hp_notch` under the crossbar so the spring
//     keeps its full length; the upper one starts `hp_step` above the seat
//     on a chamfer, because the insertion turn drops a corner there.
//   * the upper hook's tip 0.3 -> 0.6 (`hp_tip_up`), past one bead.
// Making the tip taller showed that the upper lever had been measured to the
// tip's middle. It is now measured to the catch corner, the point that has to
// clear, and that is what set 0.6, `hp_under` 1.5 and `hp_roof_lead` 42.
// Charm holes out to `hp_c_out` 6.45 (from 5.91) and gables to 5.55 (from
// 5.20): every charm's own dimensions were refitted around them.
// STRAIGHT LEGS, the same day (unprinted). From a second sketch: the upper
// leg is grown INWARD like the lower one, not outward, and its outside runs
// straight up with no taper. Each leg is one 1.6 mm bar, `hp_ui_g` to
// `hp_uo`, step-free top to bottom — the user rejected notches beside the
// crossbar's ends. So the spring is 7.0 long, not 8.2, and `hp_cb_h` came
// down 0.76 -> 0.65 to keep its strain; that costs ~25 % of its force. The upper hook now
// stands off the grown face, so the charm's chambers moved in 0.6
// (`hp_c_in` 2.45). With no taper the hole's outer wall is set by the leg's
// top corner: `hp_c_out` 6.44, about where the outward growth had it.
// A STIFF CROSSBAR, 2026-09-27 (last). The step-free pin printed and the
// charms were still loose — the pin wobbly, charms and pins both letting go.
// The user: the crossbar is too thin to hold. They are right: a hook's force
// goes as cb_h^3, and 0.65 was barely two beads. `hp_cb_h` 0.65 -> 1.0 (3.6x
// the stiffness) and `hp_hook_up` 0.90 -> 1.00, with `hp_under` 1.5 -> 1.35
// so the longer hook's lead-in stays under 44. The charm holds ~3.9x harder
// on paper. The crossbar grows DOWN (the recess is fixed), so the pivot drops:
// the charm's lever lengthens, the bar's shortens, and `hp_keep` rises.
//   * THE COST IS STRAIN: 4.9 % per charm, 6.2 % once, going into the bar —
//     past what PLA takes. The pins are printed in ABS, which the user chose
//     knowing this. If a crossbar cracks going in, 0.9 gives 4.5 / 5.4 %.
//   * The lower hooks were NOT lengthened: with the pivot lower their turn
//     going in would reach 8.3 %, and `hp_out` is the band's width limit.
//   * `hp_c_out` 6.46 -> 6.66: every charm refitted, the band's pocket
//     deepened (the crossbar's slot) — band, pins and charms all reprint.
assert(hp_strain_up <= 0.050,
       str("the crossbar bends to ", 100*hp_strain_up,
           "% every time a charm goes on — past the 5.0% allowed an ABS pin"));
// BAR HOOKS LIKE THE CHARM'S, 2026-09-28. The stiff pin printed: "sits
// quite good in a charm, but still loosy in a bracelet" — the pin pulls out
// of the bar. The user saw the upper hooks looked bigger, and they were:
// 0.85 past the wall on a 0.6 tip, against 0.70 on a 0.3 tip. The lower
// hooks now match: `hp_hook_lo` 0.85 -> 1.00 (0.85 past the wall) and
// `hp_tip_lo` 0.3 -> 0.6. That costs turn on the short lever — 8.3 % at the
// old 44 lead-in — so `hp_lead` 44 -> 50 keeps the hook lower on its leg:
// 8.0 % going in, once per pin, in ABS. The user chose this knowing it may
// crack; 6.2 % survived. `hp_out` 6.25: the band keeps its width and the
// pocket's end walls go 2.0 -> 1.85 (bracelet.scad). Charms are untouched.
assert(hp_strain_cb <= 0.082,
       str("the crossbar bends to ", 100*hp_strain_cb,
           "% as the pin goes into the bar — past the 8.2% allowed for that one-off bend"));
assert(hp_room_lo < hp_ui_g - hp_fillet - 0.8,
       "the legs' inward room eats the bar between the two leg slots");
assert(hp_c_in >= 2.0, "the charm's two chambers leave under 4 mm of charm between them");
assert(min(hp_defl_lo, hp_defl_up) >= 0.5,
       "the hooks overlap their shoulders by less than the printer rounds off");

// ----------------------------------------------------------------- the pin
// One leg, the one at +u, in (u, v): lower hook OUT, upper hook IN. The left
// leg is its mirror.
function hp_leg_pts() = [
    [hp_ui_g,         hp_v_end],
    [hp_uo,           hp_v_end],
    [hp_uo + hp_hook_lo, hp_v_end + hp_lr],          // lower lead-in
    [hp_uo + hp_hook_lo, hp_v_lt],                   // tip flat
    [hp_uo,           hp_v_lc],                      // `hp_catch_lo` catch
    [hp_uo,           hp_v_top],                     // straight up the outside
    [hp_ui_g,         hp_v_top],
    [hp_ui_g - hp_hook_up, hp_v_ut + hp_tip_up],     // upper lead-in, to the top
    [hp_ui_g - hp_hook_up, hp_v_ut],                 // tip flat
    [hp_ui_g,         hp_v_uc],                      // `hp_catch_up` catch
];                                                   // ... and straight back down

module hp_pin_raw_2d() union() {
    polygon(hp_leg_pts());
    mirror([1, 0]) polygon(hp_leg_pts());
    translate([-hp_ui_g - 0.3, hp_cb_bot]) square([2*hp_ui_g + 0.6, hp_cb_h]);
}

// The H's outline, in (u, v). The four inside corners where the crossbar
// meets the legs are filleted — they are the spring's roots — and ONLY those:
// a closing pass over the whole outline would also fill the root of every
// catch by a few hundredths and eat the hooks' clearance there.
module hp_pin_2d() union() {
    hp_pin_raw_2d();
    intersection() {
        offset(r = -hp_fillet) offset(r = hp_fillet) hp_pin_raw_2d();
        translate([-hp_ui_g, hp_cb_bot - 2*hp_fillet])
            square([2*hp_ui_g, hp_cb_h + 4*hp_fillet]);
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
// The shoulder: the hook's catch face lifted `hp_vfit`, at the catch's angle.
function hp_b_sh(u) = hp_v_lt + (hp_uo + hp_hook_lo - u) / tan(hp_catch_lo) + hp_vfit;
function hp_bar_pocket_pts() = [
    [hp_ui_g - hp_room_lo, hp_v_fl],
    [hp_out,             hp_v_fl],
    [hp_out,             hp_b_sh(hp_out)],
    [hp_uo + hp_fit,     hp_b_sh(hp_uo + hp_fit)],
    [hp_uo + hp_fit,     -hp_mouth_v],
    [hp_uo + hp_fit + hp_mouth_u, 0],
    [hp_uo + hp_fit + hp_mouth_u, 1],
    [hp_ui_g - hp_room_lo, 1],
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
function hp_c_sh(u) = hp_v_uc + (hp_ui_g - u) * hp_cr / hp_hook_up - hp_vfit;
function hp_c_rf(u) = hp_roof - (hp_ui_g - u) / tan(hp_roof_lead);
// THE HOLES ARE SMALLER THAN `hp_c_out` / `hp_c_in` SAY (2026-10-01). Those
// two were sized for the H-pin's 1.6 mm legs swinging on a bending crossbar,
// and several charms build their own shapes from them, so they stay. The
// holes themselves are cut to `hp_h_out` / `hp_h_in`, sized for the
// dovetail pin's 0.8 mm spring legs and 0.62 mm hooks: lib/charm-dovetail.scad
// asserts that pin fits them. Old charms, with the big holes, still take the
// new pin.
hp_h_out  = 5.7;    // a hole's outer wall (`hp_c_out` 6.66). 5.25 until
                    //   2026-10-02, when the legs thickened to 1.1
hp_h_in   = 2.55;   // a chamber's inner wall (`hp_c_in` 2.45). 2.7 until
                    //   2026-10-02, when the hooks grew to 0.8
assert(hp_h_out <= hp_c_out && hp_h_in >= hp_c_in,
       "the holes grew past what the charms were shaped around");
function hp_charm_hole_pts() = [
    [hp_ui_g - hp_fit, -1],
    [hp_h_out,       -1],
    [hp_h_out,       hp_roof],
    [hp_ui_g - hp_fit, hp_roof],
    [hp_ui_g - hp_fit, hp_c_rf(hp_ui_g - hp_fit)],
    [hp_h_in,        hp_c_rf(hp_h_in)],
    [hp_h_in,        hp_c_sh(hp_h_in)],
    [hp_ui_g - hp_fit, hp_c_sh(hp_ui_g - hp_fit)],
];
assert(hp_c_rf(hp_ui_g - hp_fit) - (hp_v_ut + hp_tip_up + (hp_hook_up - hp_fit) * hp_lr_up / hp_hook_up)
       >= hp_gap, "the charm's chamber roof comes down onto the hook's lead-in");
assert(hp_c_rf(hp_h_in) - hp_c_sh(hp_h_in) >= 0.2,
       "the charm's chamber pinches shut at its inner wall");

// The two holes, cut UP from z = 0 (the charm's seat face).
module charm_h_holes() {
    hp_stand(hp_slot_x) {
        polygon(hp_charm_hole_pts());
        mirror([1, 0]) polygon(hp_charm_hole_pts());
    }
    // the gables: 45-degree roofs over each leg's end, running along u
    for (s = [-1, 1])
        translate([0, s*(hp_ui_g - hp_fit + hp_h_out)/2, 0])
            rotate([90, 0, 0])
                linear_extrude(hp_h_out - (hp_ui_g - hp_fit), center = true)
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
