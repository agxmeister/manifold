// pad — the swivel foot that snaps onto the screw's ball.
//
// A ball-and-socket foot is what stops the screw from scuffing and dragging
// the workpiece round as it tightens.
//
// The socket is a real snap fit, and its geometry is set by how far the
// retaining fingers have to bend rather than by how it looks: the mouth is
// pad_lip narrower than the ball per side, so each finger must spread 0.4 mm
// as the ball's equator goes past. Four slots run the whole length of the
// thin-walled barrel and a little way into the head, which puts the finger
// root ~11.5 mm above the lip — a 2.4 mm wall bent 0.4 mm over that length is
// about 1.1% surface strain, inside what PLA survives once. Rooting the
// fingers at the top of the barrel instead (a 3 mm flexure) would be nearer
// 17% and would simply crack.
//
// The fingers only retain the pad. The clamping load runs straight down the
// solid material above the socket, which the slots stop short of.
//
// It prints upside-down, clamping face flat on the bed: the socket then opens
// upward, so the retaining lip becomes a shallow taper rather than a ceiling
// and all four slots run vertically.

include <common.scad>

// Print orientation: flipped, clamping face on the bed.
translate([0, 0, pad_face_z]) rotate([180, 0, 0]) clamp_pad();

mouth_r   = ball_d / 2 - pad_lip;                            // the snap
lip_z     = -sqrt(socket_r * socket_r - mouth_r * mouth_r);  // where it grips
barrel_z1 = socket_r + 1;      // barrel meets the head, just above the ball
barrel_z0 = -pad_barrel_h;
slot_z1   = barrel_z1 + 1.4;   // slots bite into the head, lengthening the flexure

module clamp_pad() {
    difference() {
        body();
        socket();
        slots();
    }
}

module body() {
    // head — full diameter, and solid above the socket where the load goes.
    // Its last millimetre tapers in: that is the rim resting on the bed, so
    // the chamfer relieves the elephant's foot on a face that never mates.
    translate([0, 0, barrel_z1])
        cylinder(d = pad_d, h = pad_face_z - barrel_z1 - 1);
    translate([0, 0, pad_face_z - 1])
        cylinder(d1 = pad_d, d2 = pad_d - 2, h = 1);
    // barrel — thin walled, so the fingers cut from it can actually flex
    translate([0, 0, barrel_z0])
        cylinder(d = pad_barrel_d, h = barrel_z1 - barrel_z0);
}

// Sphere above the lip; below it the mouth tapers back out to full ball
// diameter at the open end. So the ball enters freely, rides up a continuous
// ramp, and the fingers spread only over the last couple of millimetres — and
// the retaining ridge at lip_z is a blunter included angle than a cylindrical
// mouth's would be.
module socket() {
    sphere(r = socket_r);
    translate([0, 0, barrel_z0 - 1])
        cylinder(r1 = socket_r, r2 = mouth_r, h = lip_z - barrel_z0 + 1);
}

module slots() {
    for (a = [0 : pad_slots - 1])
        rotate([0, 0, a * 360 / pad_slots])
            translate([0, 0, (barrel_z0 - 1 + slot_z1) / 2])
                cube([pad_d + 2, pad_slot_w, slot_z1 - barrel_z0 + 1],
                     center = true);
}
