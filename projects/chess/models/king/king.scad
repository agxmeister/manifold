// king — the classic Staunton KING, the tallest piece, turned as a solid of
// revolution with a cross finial.
//
// Built from the SAME shared parts as the rest of the set (see
// ../../lib/staunton.scad): head (crown) + collar + body + foot. The collar is
// the shared collar (stretched slightly taller) and the foot is the shared foot
// stretched tallest of the family (zs 1.4). The body is a smooth curve through a
// few control points (`body_pts`): a long slim NECK that tapers into the collar
// with no separate cylinder, swelling into a tall bell at the foot. The flaring
// CROWN head is his own, and the CROSS — the one mark a lathe cannot turn — is a
// flat blade finial rooted into the top of the crown.
//
// A king is therefore the turned body with the CROSS unioned on top. The crown
// was traced from the reference photo; the king reaches ~93 mm — the tallest
// piece, just above the queen (~86 mm), faithful to the photo.
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: like the pawn and queen, the swelling body and shared base tiers
// descend outward and bridge without support. The classic turned overhangs — the
// underside of the crown shoulders and under the collar brim — bridge acceptably.
// The CROSS, however, is a Latin/bottony cross faithful to the photo: its arm
// undersides and bottony end-bulbs face downward, so this piece is meant to be
// printed WITH light support under the cross (the rest prints clean). That is the
// deliberate trade for a cross that matches the reference rather than a
// self-supporting diamond.

include <../../lib/staunton.scad>

$fn = 96;

// ---- Cross finial (a flat bottony cross, blade upright in the X-Z plane) ----
cross_th     = 4.0;    // blade thickness (Y) — its broad faces are vertical
cross_sw     = 3.6;    // width of the vertical shaft (X)
cross_base   = 78.35;  // z where the shaft roots down inside the crown
cross_top    = 93.35;  // z of the top of the shaft (before the top bulb)
cross_arm_cz = 88.55;  // z of the horizontal arm centre
cross_arm_r  = 3.4;    // arm bar reach from the axis (before the bulbs)
cross_arm_h  = 4.2;    // height of the arm bar
cross_bulb_r = 1.35;   // radius of the bottony end-bulbs at the three free tips

// Shared-part scales + where they sit on the axis (bottom-up).
foot_zs    = 1.4;               // foot stretched tallest of the family
collar_rs  = 1.19;           // collar widened to match the queen's collar
collar_zs  = 1.27;           // collar stretched taller to match the queen's
body_z0    = 22.46;         // body's bottom, where it meets the foot
body_h     = 23.54;        // body height (collar bottom - body bottom)
collar_z0  = body_z0 + body_h;  // 46.00 — collar seats on the body top

king();

module king() {
    union() {
        // Revolve the assembled half-section. The profile is closed back to the
        // axis along the flat base (append [0, 0]); the crown apex sits on the axis.
        rotate_extrude()
            polygon(concat(
                king_head(),                               // crown (smooth analytic profile)
                collar_pts(collar_rs, collar_zs, collar_z0),
                body_pts(king_body(), body_h, body_z0),    // slim neck + tall bell
                foot_pts(foot_zs, 0),
                [[0, 0]]                                    // close along the axis
            ));
        cross_finial();
    }
}

// The cross: a 2D bottony cross authored in X (width) and its second axis as
// height, extruded cross_th thick and stood upright so its broad faces are
// vertical. The shaft roots into the crown at cross_base; the three free tips
// (top, left, right) carry small round bulbs for the traditional bottony look.
module cross_finial() {
    translate([0, cross_th / 2, 0])
        rotate([90, 0, 0])
            linear_extrude(cross_th)
                cross_2d();
}

module cross_2d() {
    union() {
        // vertical shaft
        translate([-cross_sw / 2, cross_base])
            square([cross_sw, cross_top - cross_base]);
        // horizontal arm bar
        translate([-cross_arm_r, cross_arm_cz - cross_arm_h / 2])
            square([2 * cross_arm_r, cross_arm_h]);
        // bottony end-bulbs at the three free tips
        translate([0, cross_top])            circle(cross_bulb_r);   // top
        translate([-cross_arm_r, cross_arm_cz]) circle(cross_bulb_r); // left
        translate([ cross_arm_r, cross_arm_cz]) circle(cross_bulb_r); // right
    }
}

// Crown head [r, z], generated from a smooth analytic profile so the revolved
// surface reads as one clean curve (hand-placed points left visible facets).
// It is an elliptical DOME from the apex down to the widest shoulder, then a
// cosine TAPER inward to the collar's neck pinch. Both pieces share a vertical
// tangent at the shoulder, so they meet without a crease. The crown flares like
// the queen's coronet (shoulder ~11 mm, ~0.9x the queen) and seats on the taller
// widened collar (neck pinch r = 3.38 at z = 59.55). The cross roots into the
// dome from cross_base up.
crown_apex_z     = 82.95;   // dome apex, on the axis
crown_shoulder_z = 77.15;   // widest shoulder height
crown_shoulder_r = 11.00;   // widest shoulder radius
crown_base_z     = 59.55;   // base pinch, meets the collar neck pinch
crown_base_r     =  3.38;   // base pinch radius (= 2.84 * collar_rs)
crown_dome_seg   = 16;      // samples over the dome (apex -> shoulder)
crown_taper_seg  = 22;      // samples over the taper (shoulder -> base)

function king_head() = concat(
    // Elliptical dome: apex (a = 0) out to the widest shoulder (a = 90).
    [ for (i = [0 : crown_dome_seg])
        let (a = 90 * i / crown_dome_seg)
        [ crown_shoulder_r * sin(a),
          crown_shoulder_z + (crown_apex_z - crown_shoulder_z) * cos(a) ] ],
    // Cosine taper: shoulder (u = 0, skipped to avoid a duplicate) down to the
    // base pinch (u = 1). cos gives a vertical tangent at the shoulder to match
    // the dome, easing inward to the collar.
    [ for (i = [1 : crown_taper_seg])
        let (u = i / crown_taper_seg)
        [ crown_base_r + (crown_shoulder_r - crown_base_r) * cos(90 * u),
          crown_shoulder_z - (crown_shoulder_z - crown_base_z) * u ] ]
);

// Body control points [t, r]: t = 1 at the collar (top), t = 0 at the foot.
// A long slim NECK that eases in from the collar's bottom radius (no cylinder)
// and widens continuously — gently over the tall neck, then accelerating into a
// swelling bell that meets the foot.
function king_body() = [
    [ 1.00,  5.08 ],  // top, meets the (widened) collar
    [ 0.86,  4.90 ],  // long slim neck, a gentle waist then easing outward
    [ 0.72,  4.80 ],
    [ 0.58,  4.85 ],
    [ 0.46,  5.15 ],
    [ 0.36,  5.60 ],  // neck swells into the bell
    [ 0.27,  6.25 ],
    [ 0.19,  7.05 ],
    [ 0.12,  7.90 ],
    [ 0.06,  8.85 ],
    [ 0.00, 10.10 ],  // bottom, meets the foot
];
