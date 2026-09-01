// Shared dimensions for the alphabet train — the numbers that tie the
// platform, the wheels and the letters into one system. Renders nothing on
// its own; every model includes it.
//
// z = 0 is the GROUND, not the print bed. Ride height is what couples the
// three components together, so every height here is measured from the floor
// the train rolls on.

$fn = 48;

// ---------------------------------------------------------------------------
// Wheels — models/wheel. Four per platform, snapped on.
// ---------------------------------------------------------------------------
// The wheel is deliberately larger than the body needs. Diameter is the only
// lever this design has: it sets the axle height, and the axle height is what
// pays for BOTH of the things that keep getting asked for — ground clearance
// under the chassis, and a peg thick enough to stop worrying about. Every 1 mm
// of wheel radius can be spent on either, and 26 -> 34 bought both at once.
wheel_dia    = 34;
wheel_w      = 8;              // grows with the diameter, or the wheel reads as
                               //   a disc rather than a wheel
wheel_cham   = 0.8;            // break on both rim edges
wheel_gap    = 1.2;            // side clearance, wheel face to chassis flank
wheel_boss_d = 16.0;           // rubbing boss, so the whole face does not drag.
                               //   It has to stay OUTSIDE the socket's flared
                               //   mouth (13.1 across) or it drops into it and
                               //   the wheel binds — 16 leaves a 1.45 mm land
wheel_boss_h = 1.0;
axle_z       = wheel_dia / 2;  // 17 — axle height, and so the whole ride height

// The snap axle. THIS JOINT HAS BROKEN ON A REAL PRINT ONCE AND BEEN CALLED TOO
// THIN TWICE. Read all of this before changing a number in it.
//
// The peg belongs to the WHEEL, not the chassis: a peg on the chassis points
// sideways, which makes its barb a horizontal overhang with an unprintable
// retaining face, while a peg on the wheel points straight up out of the bed.
//
// Two facts govern everything here:
//
//  1. A barb cannot pass a smaller hole unless something gives, and the only
//     thing that CAN give is the peg. So the peg is slit into two fingers, and
//     a snap peg is therefore never solid. "Make the pin solid" and "make it a
//     snap" are mutually exclusive; the only way to a solid pin is to drop the
//     snap (a separate glued axle, or a quarter-turn bayonet).
//  2. The finger is loaded ACROSS the print layers — the peg stands up on the
//     bed, so every layer boundary is perpendicular to the tension in a bending
//     finger. That is PLA's weakest, most brittle direction. Budget well under
//     1% peak strain (1.5*t*delta/L^2), not the 2-3% bulk PLA would allow.
//
// Given that, the fingers can only be made thicker by making the whole peg
// fatter, which needs a bigger bore — and the bore is capped by the CHASSIS
// HEIGHT, not by its width, because the chamber is a horizontal hole and the
// floor under it has to survive. At wheel_dia 22 (deck 22, axle 11) the ceiling
// was a 5.4 mm shaft and 1.9 mm fingers. Every step up in wheel diameter lifts
// the axle and buys shaft section with it, at a LOWER strain than before,
// because the journal grows in the same move.
//
// History, so none of it gets undone:
//   * 4.6 mm shaft, 1.3 mm fingers, 3 mm journal, square slit root, no lead-in
//     -> snapped on the first attempt to fit a wheel.
//   * 5.4 mm shaft, 1.9 mm fingers, 7 mm journal, radiused root, flared mouth
//     -> 0.53% strain, but still judged too thin.
//   * 7.6 mm shaft, 3.15 mm fingers, 9 mm journal -> 0.51% strain, ~29 N push.
//   * 9.3 mm shaft, 4.0 mm fingers, 12 mm journal -> 0.41% strain, ~37 N. This
//     is the current one, and the wheel growing to 34 is what paid for it: the
//     axle rose to 17, which let the chamber grow to 12 mm WITHOUT thinning the
//     floor under it (3.0 mm, up from 2.85). 52% more finger section at a lower
//     strain for 8 N more push — and the push is a one-time assembly cost,
//     while the section is what survives a child levering on a fitted wheel.
axle_d        = 9.3;               // peg shaft — the surface the wheel turns on
axle_hole_d   = axle_d + 0.8;      // 10.1 — running fit, the wheel has to spin
axle_barb_d   = axle_hole_d + 0.7; // 10.8 — a 0.35 mm shoulder behind the wall
// The journal is the wall the barb passes, and it is also the FINGER LENGTH.
// Stiffness goes as 1/L^3 and strain as 1/L^2, so lengthening it is the one
// change that makes the fingers thicker without making them harsher to fit.
// 12 mm a side still leaves 8 mm of solid between the two chambers.
axle_neck_l   = 12.0;              // journal length, and the wall the barb passes
axle_relief_d = axle_barb_d + 1.2; // 12.0 — chamber the barb springs back into
axle_relief_l = 5.5;               // deep enough that the peg TIP never lands
                                   //   before the boss does: tip reaches 15.7 mm
                                   //   below the flank, floor is at 17.5
axle_mouth_lead = 1.5;             // flare at the hole mouth, so the peg self-centres
// The slit, halved from 2.6 at the owner's call: the fingers were still judged
// fragile, and a narrower slit makes them thicker (2.5 -> 3.15 mm). It only has
// to close by 0.7 mm, so 1.3 still leaves 0.6 of margin. The trade runs the other
// way on strain, though — a thicker finger strains MORE for the same deflection
// and pushes harder. That is why the journal is lengthened every time the finger
// is thickened: length is the term that pays both back.
axle_slot_w   = 1.3;
axle_slot_z   = 1.5;               // slit floor, measured up from the wheel's outer
                                   //   face. Sunk 0.5 deeper than before to buy
                                   //   back some finger length against the
                                   //   thicker section. 1.5 mm of solid disc is
                                   //   left under a 1.3 mm slot.
axle_slot_r   = axle_slot_w / 2;   // and it is ROUNDED: a square corner here is a
                                   //   stress riser exactly at the finger root,
                                   //   which is where the first version failed
axle_retain_h = 1.0;               // rise of the retaining cone — 37 deg from vertical
axle_lead_h   = 2.5;               // the lead-in ramp above it. Lengthened with the
                                   //   fatter barb: there is 4.0 mm of diameter to
                                   //   shed now, and over 2.0 that was a 45 deg nose
                                   //   that had to be shoved rather than pushed
axle_tip_d    = 6.8;               // the ramp stops short of a point, or the slit
                                   //   leaves the fingers as slivers at the tip

// ---------------------------------------------------------------------------
// Chassis
// ---------------------------------------------------------------------------
body_l    = 64;
body_w    = 42;    // wider than it looks necessary: the axle chamber needs it
// Ground clearance. It is bought straight out of the wheel radius: the floor
// under the axle chamber is wheel_dia/2 - body_bot - axle_relief_d/2, and that
// floor has to stay around 3 mm. At wheel_dia 26 the most this could be was 5;
// at 34 it can be 8 and the floor is thicker than it was, not thinner.
body_bot  = 8;      // underside — the ground clearance
body_top  = wheel_dia;   // 34 — deck, deliberately level with the wheel tops
body_r    = 6;      // plan corner radius

// The nose extension. It exists so the coupler socket can sit clear of the
// letter groove, which needs the whole deck. It is a full-height prism, so it
// adds no overhang — just length. It costs 9 mm of spacing between letters.
prow_l    = 9;      // how far it reaches past the body's front face
prow_w    = 28;     // width at its tip. Narrower than it looks necessary: the
                    //   prow's TIP CORNERS are what strike the next car's rear
                    //   face in a turn, so trimming them is what let the key be
                    //   shortened. 28 leaves 6.5 mm prongs at the tip, and the
                    //   prong is 12.5 mm wide back at the throat where the load
                    //   actually is.
body_cham = 1.2;    // 45 deg break around the top edge
wheelbase = 36;    // 34 mm wheels at +/-18 now stand 3 mm proud of the body's
                   //   ends. That is deliberate rather than tolerated: the
                   //   wheels sit at |y| >= 22.2 and the prow tip is only 14
                   //   half-wide, so there is nothing for them to foul in the
                   //   12 mm gap between coupled cars

// ---------------------------------------------------------------------------
// The letter interface — a long groove down the deck.
//
// A LETTER IS NOTHING BUT A LETTER. No plinth, no tongue, no tab: it is the bare
// glyph, and it attaches by standing in a groove, resting on the groove's floor.
// This is a learning toy, so anything on a letter that is not the letter is a
// distraction.
//
// That is what makes the groove long. The letter's own footprint has to fit
// inside it, and the footprint is the full width of the letter — so the groove
// is 52 mm on a 64 mm deck. Which in turn is why the coupler socket had to move
// out of the body and into a nose extension: it used to occupy the deck from
// x = 19.2 outward, and the groove now needs the deck out to x = 26.
//
// Letters are buried letter_slot_d and stand letter_size - letter_slot_d proud.
// ---------------------------------------------------------------------------
letter_t          = 7.0;   // thickness of the letter

// ---------------------------------------------------------------------------
// THE GROOVE IS OVERSIZE AND A SEPARATE WEDGE CLAMPS THE LETTER IN IT.
//
// Four straight-slot fits were tried — 0.5, 0.2, 0.05 and finally 0.0 mm a side
// — and every one came out loose on the machine. That is the lesson, not the
// numbers: a straight slot's grip IS the print tolerance, nothing in either part
// can give, and the tolerance is not knowable in advance. Guessing it again was
// never going to work.
//
// So the groove is deliberately too wide, and a tapered clamp (models/platform/
// clamp.scad) is pushed into the gap beside the letter. It sinks until it jams,
// wherever that happens to be. The fit is then set by geometry rather than by
// hitting a dimension: whatever the groove and the letter actually measure, the
// wedge finds the depth that takes up the difference.
// ---------------------------------------------------------------------------
// The wedge's LETTER-FACING FACE IS FLAT and its ramp faces the groove wall.
// That is not a detail. The letter stands 40 mm proud, so a face that thickens
// toward it above the deck would drive into it; a flat face lies against it for
// the wedge's whole height and the bulge goes the other way, into free air. Get
// this backwards and the clamp cannot seat at all.
//
// It jams where its own thickness equals the gap:
//     seat = (gap - clamp_t_bot) / clamp_slope
// so the working band is gaps from clamp_t_bot up to
// clamp_t_bot + letter_slot_d*clamp_slope = 1.2 .. 2.2 mm, against a nominal
// 1.7. That is +/-0.5 mm of groove width absorbed — far more than the tolerance
// that four straight-slot attempts kept missing by.
// A WAVE SPRING lives permanently in one side of the groove and presses every
// letter against the opposite wall. It is printed separately and fitted once.
//
// This is what four straight-slot fits (0.5, 0.2, 0.05 and 0.0 mm a side) were
// reaching for and could never get: a straight slot's grip IS the print
// tolerance, because neither the letter nor the deck can give. A spring gives.
// It delivers roughly the same force anywhere in its travel, so the groove can
// print wide or narrow and the letter is still clamped — and unlike a wedge,
// nothing has to be removed and refitted to change a letter. Letters stay a
// one-handed drop-in.
//
// It bends IN THE PRINT PLANE — the strip lies along the groove and flexes
// across it — so the bending runs along the layer lines instead of across them.
// That is the opposite of the wheel peg's problem, and it is why this can be
// 1 mm thin without being fragile.
// A SINGLE-SPAN CROWNED LEAF. No intermediate support, and that is the point.
//
// The version before this waved back to the wall in the middle of its length,
// and the front face directly opposite that node was therefore RIGID — a letter
// bearing there could not push it at all, so it would not seat. Any support
// between the ends does that: it pins the contact face where it sits.
//
// So the leaf is anchored only at its two ends and bows toward the letter in
// between. Measured on all 26 exports, every letter's foot falls inside
// x = -17.8..18.3, and only P and F miss the centre (their feet sit at
// -13.2..-5.4 and -11.9..-4.1) — so a contact region of about +/-8 mm about the
// centre catches every letter, which one crowned span delivers easily.
//
// Sizing, with force and the stress it sits at forever linked by:
//     F = 4*E*h*t^3*delta / L^3        sigma = 6*E*t*delta / L^2
// A long span lets the leaf be THICK, and thickness is what carries force:
// 3.6 mm over 35.6 mm gives ~21 N at ~22 MPa. Stress is the ceiling, not yield —
// PLA much above ~25 MPa creeps its preload away over months.
spring_space    = 4.5;   // the gap the spring lives in
spring_preload  = 0.42;  // how proud of the letter's face the crown sits
spring_t        = 4.0;   // leaf thickness; leaves 0.9 mm of back clearance
// The anchors sit OUTBOARD of every letter's foot (measured: none reaches past
// x = 18.3, the anchors start at 19.8), so no letter can ever bear on the rigid
// ends and they need no recess. That matters because a recess is what forces the
// bow to be tall, and a tall bow falls away from the letter fast: at 0.5 mm of
// recess the leaf was only proud of the letter over +/-8.4 mm, and A — whose two
// feet straddle the centre at |x| = 10..18 — compressed it 0.02 mm instead of
// 0.42. With no recess the WHOLE span is live.
spring_recess   = 0.0;
spring_anchor_l = 6.0;   // anchor block length at each end
// How far the anchors drop into their pockets. Shortened 6.0 -> 2.5 when the
// axle chamber grew: the chamber is a teardrop, so its 45 deg gable reaches
// 0.707*axle_relief_d = 8.5 mm above the axle, to z = 25.5, and a 6 mm leg put
// the pocket floor at 23.8 — the two voids met and the chassis came out genus 2
// instead of 0. Raising the floor to 27.3 is the cheap side of that trade: the
// legs only locate the spring and stop it creeping up (a drop of glue does the
// rest), while the chamber is what holds the wheel on. Nothing about the leaf's
// bow, span, thickness or anchor length moves, so the letter engagement sweep
// is unaffected. Keep pocket floor = body_top - letter_slot_d - spring_leg_l -
// spring_fit above axle_z + 0.707*axle_relief_d.
spring_leg_l    = 2.5;
spring_fit      = 0.2;

letter_slot_w     = letter_t + spring_space;   // 11.5 — letter plus the spring

letter_slot_l     = 52;    // must take the widest letter's own footprint
letter_slot_d     = 4;     // shallow: the letter stands on the groove floor
letter_slot_lead  = 0.4;   // corner break, and the lead-in for starting a letter
letter_bury       = letter_slot_d;
spring_l          = letter_slot_l - 2 * spring_fit;   // 51.6

// The glyph. The font is NOT free to change casually — see models/letter/
// glyph.scad. Helvetica Bold is verified present, and is the narrowest bold sans
// on this machine (W is 1.27x the cap height, against Verdana Bold's 1.46),
// which matters because the widest letter is what sets the groove length.
// Condensing to 0.85 buys back cap height for the same footprint: at these
// numbers W is 47.5 mm wide inside a 52 mm groove.
letter_font      = "Helvetica:style=Bold";
letter_size      = 44;     // = cap height in mm for this face
letter_condense  = 0.85;   // horizontal scale

// ---------------------------------------------------------------------------
// The coupler — a vertical round key at the back, a keyhole socket in the nose.
//
// Every surface of it is a vertical prism, so there is nothing anywhere in the
// joint for the printer to lay down in mid-air: no tongue passing under a nose,
// no tunnel, no roof. That is the whole reason it is shaped this way. Couple two
// platforms by lowering one over the other's key.
//
// TWO THINGS FIGHT EACH OTHER HERE, and the first version got both wrong.
// Retention is (key diameter - narrowest slot width); swing is how far the neck
// can rotate before it jams in that same slot. Narrow the slot and it holds but
// will not turn; widen it and it turns but pulls out. v1 had a 7.0 mm slot on an
// 8.0 mm key — 0.5 mm of interlock, which a real print did not hold — and still
// only managed 19 deg.
//
// Three things break the deadlock:
//
//   * A WEDGE-SHAPED slot instead of a parallel one. The narrow point is then
//     only ~3.6 mm out from the key axis, where the neck barely sweeps, and the
//     slot is generous everywhere the neck actually needs room. The throat is
//     formed where the wedge crosses the bore circle, not by a wall you place.
//   * A TAPERED neck — thin where it passes that throat, thick at its root where
//     the load is. The thin end is what buys the angle; the thick end is what
//     makes it strong.
//   * A flared mouth at the nose face, which is the OTHER station that jams.
//
// Result: 1.45 mm of interlock (3x v1) at about 30 deg of swing (1.6x v1), for
// 1 mm of extra key diameter.
// ---------------------------------------------------------------------------
coupler_key_d    = 9.0;
coupler_bore_d   = coupler_key_d + 0.6;   // 9.6 — a free swivel
// Key axis, behind the rear face. This sets the gap between coupled cars, and it
// is as short as it can be while the SWING is still limited by the coupler's own
// slot rather than by the cars fouling each other.
//
// It went 14 -> 20 when the wheels grew to 34. That is the price of the big
// wheels and it is worth knowing why: a 34 mm wheel on a 36 mm wheelbase stands
// 3 mm PROUD of each body end, and the wheelbase cannot be closed up to hide it
// (36 is already the minimum at which two 34 mm wheels on one side clear each
// other). So the wheels, not the bodies, became the nearest parts of two coupled
// cars, and at 14 they met at yaw 20 — worse than the 25 the bodies used to
// manage. Measured sweep at 20: free to 25, first contact at 30 and it is the
// coupler's own throat again (2 mm^3 at y = 3.1..4.0, exactly where the slot
// grips), wheels joining in at 33, a real collision by 38. Going on to 22 buys
// almost nothing, which is the sign that the constraint has handed back to the
// slot where the design wants it.
coupler_key_x    = 20;
coupler_bore_x   = 8.0;  // bore axis, inboard of the PROW TIP
coupler_gap      = coupler_key_x - coupler_bore_x;   // 12 mm between bodies

// The slot, as a wedge: this width at the bore axis, opening out to
// coupler_slot_face_w at the nose face. Neither number is the throat — the
// throat is where this wedge crosses the bore circle. Narrowing coupler_slot_w
// tightens the throat (more grip) without costing swing, because it moves the
// throat closer to the key axis at the same time.
// The wedge's SLOPE matters as much as its throat. The neck jams on the wedge
// WALL, not at the throat: at 25 deg the first version fouled at 5.8 mm out from
// the key axis, where the wall was opening at 0.50 mm of half-width per mm and
// the neck's corner needed 0.54. The wall has to open faster than sin(theta).
coupler_slot_w      = 0.2;
coupler_slot_face_w = 15.0;

// The neck: constant w0 for coupler_neck_flat out from the key, then flaring to
// w1 at its root. The flat section is the part that lives inside the slot, and
// keeping it at its thinnest right there is worth about 10 deg of swing — a
// neck that starts tapering immediately is already 25% wider by the time it
// reaches the throat. The flare is what makes the root strong.
coupler_neck_w0   = 2.2;
coupler_neck_w1   = 5.0;
coupler_neck_flat = 7.0;

// The coupler occupies only the BOTTOM HALF of the body, so the deck above it is
// untouched and the top surface carries nothing but the letter groove. That
// costs the socket its free ride: it is now a pocket in the underside with a
// CEILING, where before it was a hole cut clean through. So the ceiling is
// gabled — a 45 deg cone over the bore, a 45 deg hip roof over the wedge — and
// both apexes have to stay clear of the letter groove above.
coupler_h    = (body_top - body_bot) / 2;   // 10.5
coupler_lead = 1.5;   // taper on the key top, and the funnel's HEIGHT
// The funnel's flare is deliberately narrower than its height: at 1.5 x 1.5 it
// is a 45 deg downward surface, right on the limit, and the overhang check
// flagged it. 0.8 puts it at 28 deg from vertical and still opens the mouth by
// 1.6 mm, which is what a child actually aims with.
coupler_funnel_w = 0.8;
