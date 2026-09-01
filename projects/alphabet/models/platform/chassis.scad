// chassis — the wheeled truck that carries one letter.
//
// The main part of the platform model: one per letter, with four wheels (see
// wheel.scad) snapped into its flanks. Couple them nose to tail and the word
// rolls. It prints lying on its flat underside with the deck facing up, and
// nothing on it needs support in that pose.
//
//   * a slot in the deck that a letter is simply dropped into
//   * a stepped hole in each flank that a wheel's snap peg clicks into
//   * a round key at the back and a keyhole socket in the nose, so platforms
//     link up — every face of that joint is a vertical prism
//
// Every dimension lives in ../../lib/common.scad.

include <../../lib/common.scad>

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

// A slab with rounded plan corners, spanning z0..z1.
module rounded_slab(l, w, r, z0, z1) {
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * (l/2 - r), sy * (w/2 - r), z0])
            cylinder(h = z1 - z0, r = r);
}

// A teardrop cross-section: a circle with a 45 deg gable on top. Horizontal
// holes are bored with this so their roof never exceeds 45 deg and the printer
// does not have to bridge a ceiling that curves over into the horizontal.
module teardrop_2d(d) {
    hull() {
        circle(d = d);
        translate([0, d * 0.707]) circle(d = 0.01);
    }
}

// A teardrop hole boring inward from the +y flank, gable up.
module teardrop_hole(d, len, y0) {
    translate([0, y0, axle_z]) rotate([90, 0, 0])
        linear_extrude(len) teardrop_2d(d);
}

// ---------------------------------------------------------------------------
// The chassis body
// ---------------------------------------------------------------------------

// Where the socket's reference face is: the tip of the nose extension.
nose_x = body_l/2 + prow_l;

// The nose extension. Its only job is to carry the coupler socket clear of the
// letter groove, and since the socket is now only coupler_h tall, so is this: it
// stops at the same height as the key, which leaves the deck above it a clean
// rectangle. A tapered prism either way — no overhang anywhere. Built separately
// from the body rather than folded into one 2D profile, because the body's top
// chamfer is a hull() of two slabs and hull() is convex: a single profile with a
// narrowing prow has a reentrant corner that hull would fill in.
module prow_plate(inset, z0, z1) {
    translate([0, 0, z0]) linear_extrude(z1 - z0)
        polygon([
            [body_l/2 - 4,  -(body_w/2 - 2 - inset)],
            [nose_x - inset, -(prow_w/2 - inset)],
            [nose_x - inset,   prow_w/2 - inset],
            [body_l/2 - 4,    body_w/2 - 2 - inset],
        ]);
}

module body() {
    hull() {
        rounded_slab(body_l, body_w, body_r, body_bot, body_top - body_cham);
        rounded_slab(body_l - 2*body_cham, body_w - 2*body_cham, body_r - body_cham,
                     body_top - body_cham, body_top);
    }
    prow_top = body_bot + coupler_h;
    hull() {
        prow_plate(0, body_bot, prow_top - body_cham);
        prow_plate(body_cham, prow_top - body_cham, prow_top);
    }
}

// ---------------------------------------------------------------------------
// The letter slot: a straight pocket with a flared mouth
// ---------------------------------------------------------------------------

// Two pockets in the groove floor that the spring's legs drop into. They are
// what locates it and stops it creeping up when a letter is pulled out; a drop
// of glue in each makes it permanent. They sit at the spring's END NODES, where
// its back is already flat against the wall.
module spring_pockets() {
    span = spring_l - 2 * spring_anchor_l;
    for (sx = [-1, 1])
        translate([(sx > 0 ? span/2 : -spring_l/2) - spring_fit,
                   letter_slot_w/2 - (spring_space - spring_recess) - spring_fit,
                   body_top - letter_slot_d - spring_leg_l - spring_fit])
            cube([spring_anchor_l + 2*spring_fit,
                  spring_space - spring_recess + spring_fit + 0.1,
                  spring_leg_l + spring_fit + 0.1]);
}

// The pocket is RECTANGULAR in plan, and it has to be. A stadium-section pocket
// (which is what this was) has rounded ends in the plan view — but a letter is a
// flat plate, so its tongue has square ends, and the four corners bite 0.29 mm
// into those rounded ends.
//
// The walls are STRICTLY VERTICAL, on the owner's instruction. It was a wedge
// before — see the note in lib/common.scad for what that bought and what a
// straight slot gives up.
module letter_slot() {
    translate([-letter_slot_l/2, -letter_slot_w/2, body_top - letter_slot_d])
        cube([letter_slot_l, letter_slot_w, letter_slot_d + 1]);
    spring_pockets();
    // corner break at the mouth, and what a child starts the letter into
    hull() {
        translate([-letter_slot_l/2, -letter_slot_w/2,
                   body_top - letter_slot_lead])
            cube([letter_slot_l, letter_slot_w, 0.01]);
        translate([-(letter_slot_l/2 + letter_slot_lead),
                   -(letter_slot_w/2 + letter_slot_lead), body_top + 0.5])
            cube([letter_slot_l + 2*letter_slot_lead,
                  letter_slot_w + 2*letter_slot_lead, 0.01]);
    }
}

// ---------------------------------------------------------------------------
// The coupler, back half: the key
//
// A round column on a web, standing coupler_h tall — the BOTTOM HALF of the
// body, so the deck above stays clear and the top surface is symmetrical. Both
// are vertical prisms rising off the bed, so neither can hang; only the top is
// tapered, and a taper at the top is free.
// ---------------------------------------------------------------------------

// The web is thin and PARALLEL where it passes through the socket, then flares
// to a thick root inside the body. Keeping it at its thinnest across the whole
// slot is what buys the swing angle; the flare is what makes it strong.
module coupler_web() {
    kx = -(body_l/2 + coupler_key_x);
    rx = -body_l/2 + 4;          // root, buried 4 mm inside the body
    fx = kx + coupler_neck_flat;   // end of the thin, constant section
    translate([0, 0, body_bot]) linear_extrude(coupler_h)
        polygon([
            [kx, -coupler_neck_w0/2],
            [fx, -coupler_neck_w0/2],
            [rx, -coupler_neck_w1/2],
            [rx,  coupler_neck_w1/2],
            [fx,  coupler_neck_w0/2],
            [kx,  coupler_neck_w0/2],
        ]);
}

module coupler_column() {
    kx = -(body_l/2 + coupler_key_x);
    translate([kx, 0, body_bot]) {
        cylinder(h = coupler_h - coupler_lead, d = coupler_key_d);
        // the taper is the lead-in the child aims with, and it points up
        translate([0, 0, coupler_h - coupler_lead])
            cylinder(h = coupler_lead, d1 = coupler_key_d,
                     d2 = coupler_key_d - 2 * coupler_lead);
    }
}

// ---------------------------------------------------------------------------
// The coupler, front half: the keyhole socket
//
// A pocket in the UNDERSIDE of the nose, coupler_h deep — not a hole through the
// deck. That keeps the top surface clean, and it means the socket now has a
// ceiling to worry about, which is exactly the failure this project keeps
// re-learning. So the ceiling is built at 45 deg: a cone over the bore and a hip
// roof over the wedge, both self-supporting, both clear of the letter groove.
// The funnel stays at the BOTTOM, because that is the mouth the key enters
// through — and a cone opening downward at the underside grows off the bed.
// ---------------------------------------------------------------------------

// The socket in plan: the bore circle, plus a WEDGE opening toward the nose
// face. The wedge is what retains the key, and the narrow point — the throat —
// is where the wedge crosses the circle, not at either end of it. That is the
// point: it lands close in to the key axis, where the neck hardly sweeps at all.
module socket_profile() {
    bx = nose_x - coupler_bore_x;
    translate([bx, 0]) circle(d = coupler_bore_d);
    slot_wedge_2d();
}

// Just the wedge half of the profile — the hip roof is built over this alone.
module slot_wedge_2d() {
    bx = nose_x - coupler_bore_x;
    fx = nose_x + 1;
    polygon([
        [bx, -coupler_slot_w/2],
        [fx, -coupler_slot_face_w/2],
        [fx,  coupler_slot_face_w/2],
        [bx,  coupler_slot_w/2],
    ]);
}

// The 45 deg ceiling. Two pieces, unioned: a cone closing over the bore, and a
// hip roof closing over the wedge. Both rise at 45 deg from every edge, so the
// void's ceiling is nowhere shallower than that — and because both are
// continuous, their union has no ledge where they meet.
module socket_roof() {
    z0 = body_bot + coupler_h;
    bx = nose_x - coupler_bore_x;
    translate([bx, 0, z0])
        cylinder(h = coupler_bore_d/2, d1 = coupler_bore_d, d2 = 0);
    hull() {
        translate([0, 0, z0]) linear_extrude(0.01) slot_wedge_2d();
        translate([bx, 0, z0 + coupler_slot_w/2])
            cube(0.01, center = true);
        translate([nose_x + 1, 0, z0 + coupler_slot_face_w/2])
            cube(0.01, center = true);
    }
}

// The flared mouth at the underside, which is what a child aims the key into.
//
// It is built as TWO pieces for the same reason the roof is: hull() is convex,
// and the socket profile — a circle with a wedge running off one side — is not.
// Hulling the whole profile fills the wedge's two reentrant corners, and where
// that convexified cut steps back to the true profile it leaves a horizontal,
// downward-facing ledge hanging 1.5 mm above the plate. That was real: two of
// them, 9.6 x 2.9 mm, at (36.4, +/-5.2, 6.5).
module socket_funnel() {
    w  = coupler_funnel_w;
    bx = nose_x - coupler_bore_x;
    translate([bx, 0, body_bot - 0.01])
        cylinder(h = coupler_lead, d1 = coupler_bore_d + 2*w, d2 = coupler_bore_d);
    translate([0, 0, body_bot - 0.01]) hull() {
        linear_extrude(0.01) offset(delta = w) slot_wedge_2d();
        translate([0, 0, coupler_lead]) linear_extrude(0.01) slot_wedge_2d();
    }
}

module coupler_socket() {
    // the pocket: up from the underside, stopping half way
    translate([0, 0, body_bot - 1])
        linear_extrude(coupler_h + 1) socket_profile();
    socket_roof();
    socket_funnel();
}

// ---------------------------------------------------------------------------
// The axle sockets
// ---------------------------------------------------------------------------

// Stepped hole in one flank: a neck the wheel's barb is pushed through, then a
// chamber it springs back into. Both bored as teardrops — they are horizontal
// holes, and a round ceiling in a horizontal hole has to be bridged.
module axle_socket() {
    teardrop_hole(axle_hole_d,   axle_neck_l + 1, body_w/2 + 1);
    teardrop_hole(axle_relief_d, axle_relief_l,   body_w/2 - axle_neck_l);
    // Flared mouth. Without it the wheel is offered up against a flat flank and
    // goes in crooked, which side-loads one finger instead of compressing both
    // — that is how the fingers got broken on the first real print.
    hull() {
        teardrop_hole(axle_hole_d + 2*axle_mouth_lead, 0.01, body_w/2 + 0.01);
        teardrop_hole(axle_hole_d, 0.01, body_w/2 - axle_mouth_lead);
    }
}

// ---------------------------------------------------------------------------

module chassis() {
    difference() {
        union() {
            body();
            coupler_web();
            coupler_column();
        }
        letter_slot();
        coupler_socket();
        for (sx = [-1, 1]) translate([sx * wheelbase/2, 0, 0]) {
            axle_socket();
            mirror([0, 1, 0]) axle_socket();
        }
    }
}

chassis();
