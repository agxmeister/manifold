// pawn — the classic Staunton PAWN, turned as a solid of revolution.
//
// The humblest piece of the set and the CANONICAL Staunton shape: its foot,
// collar and neck are the shared parts every other turned piece is built from
// (see ../../lib/staunton.scad). The pawn simply uses them at scale 1 and adds
// its own ball head and bell body.
//
// A pawn is therefore just:  head (ball) + collar + neck + body (bell) + foot,
// stacked bottom-up into one [r, z] profile and revolved with rotate_extrude().
// The measured half-section below was traced from a reference photo pixel by
// pixel and scaled so the foot reaches r = 16 mm (a 32 mm foot, the set's shared
// footprint). The shared parts carry that footprint for the whole family.
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: everything below the widest ring of each feature flares outward
// as it descends, so the skirt and base bridge without support. The downward-
// facing undersides are the classic turned overhangs — the underside of the ball
// where it necks in, and the underside of the collar brim. Their spans are small
// (a few mm), so they bridge acceptably on most printers; add light support only
// if you want the crispest finish on the ball and collar.

include <../../lib/staunton.scad>

$fn = 96;

// Where the shared parts sit on the axis (bottom-up). The pawn uses the canonical
// foot, collar and neck at scale 1, so these heights match the canonical values.
foot_top   = foot_h;             // 14.22 — body seats on the foot here
body_top   = 23.47;              // top of the bell / bottom of the neck
neck_r     = 4.27;               // neck radius = collar's bottom radius
neck_h     = 2.13;               // straight neck between body and collar
collar_z0  = body_top + neck_h;  // 25.60 — collar seats on the neck here

pawn();

module pawn() {
    // Revolve the assembled half-section. The profile is closed back to the axis
    // along the flat base (append [0, 0]); the apex already sits on the axis.
    rotate_extrude()
        polygon(concat(
            pawn_head(),                          // ball, on the axis
            collar_pts(1, 1, collar_z0),          // shared collar
            neck_pts(neck_r, neck_h, body_top),   // shared neck
            pawn_body(),                          // bell
            foot_pts(1, 0),                       // shared foot
            [[0, 0]]                              // close along the axis
        ));
}

// Ball head [r, z], apex on the axis down to the last point above the collar's
// neck pinch. Traced from the photo.
function pawn_head() = [
    [  0.00,  48.76],  // ball apex
    [  3.02,  48.36],
    [  4.03,  47.64],
    [  4.98,  46.93],
    [  5.57,  46.22],
    [  5.93,  45.51],
    [  6.28,  44.80],
    [  6.52,  44.09],
    [  6.76,  43.38],  // ball widest
    [  6.76,  42.67],
    [  6.76,  41.96],
    [  6.76,  41.24],
    [  6.52,  40.53],
    [  6.28,  39.82],
    [  5.93,  39.11],
    [  5.57,  38.40],
    [  4.98,  37.69],
    [  4.03,  36.98],  // necks in toward the collar pinch
];

// Bell body [r, z], from just below the neck down to the top of the foot. The
// skirt flares outward as it descends, so it bridges without support.
function pawn_body() = [
    [  4.50,  22.76],  // body begins below the neck
    [  4.62,  22.04],
    [  4.74,  21.33],
    [  4.98,  20.62],
    [  5.21,  19.91],
    [  5.45,  19.20],
    [  5.81,  18.49],
    [  6.16,  17.78],
    [  6.76,  17.07],
    [  7.47,  16.36],
    [  8.53,  15.64],
    [ 10.07,  14.93],  // meets the top of the foot
];
