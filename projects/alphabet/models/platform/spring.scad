// spring — the wave spring that clamps every letter in the deck groove.
// One per platform, printed separately and fitted once; it then stays put.
//
// The groove is deliberately wider than a letter. This lives down one side of
// it and presses each letter against the opposite wall. Letters stay a plain
// drop-in — nothing has to be removed to change one.
//
// Why a spring and not a sized slot: four straight-slot fits were printed
// (0.5, 0.2, 0.05 and 0.0 mm a side) and every one came out loose, because a
// straight slot's grip IS the print tolerance — neither the letter nor the deck
// can give. A spring gives, and delivers much the same force anywhere in its
// travel, so the fit stops depending on hitting a dimension.
//
// It flexes IN THE PRINT PLANE: the strip runs along the groove and bends across
// it, so the bending stress runs along the layer lines rather than across them.
// That is the exact opposite of the wheel peg's failure, and it is what lets
// this be 1 mm thin without being fragile.

include <../../lib/common.scad>

spring_span  = spring_l - 2 * spring_anchor_l;              // 35.6
spring_bow   = spring_preload + spring_recess;              // 0.92
spring_front = -(spring_space - spring_recess);             // anchors' front face

// The bow: 1 at mid-span, 0 at each anchor.
function bow(x) = 0.5 + 0.5 * cos(360 * x / spring_span);

// Plan outline. y = 0 is the back, against the groove wall. Anchors at the two
// ends run right back to it; between them the leaf bows toward the letter and is
// clear of the wall so it can deflect.
module spring_2d(n = 96) {
    fx = [for (i = [0:n]) -spring_span/2 + spring_span * i / n];
    back  = concat([[-spring_l/2, 0]],
                   [for (x = fx) [x, spring_front - spring_bow * bow(x) + spring_t]],
                   [[spring_l/2, 0]]);
    front = concat([[spring_l/2, spring_front]],
                   [for (i = [n:-1:0]) let (x = fx[i])
                        [x, spring_front - spring_bow * bow(x)]],
                   [[-spring_l/2, spring_front]]);
    polygon(concat(back, front));
}

// The spring in USE coordinates: back face on y = 0, top face on z = 0.
module spring_solid() {
    translate([0, 0, -letter_slot_d]) linear_extrude(letter_slot_d) spring_2d();
    // the anchors continue down into their pockets
    for (s = [-1, 1])
        translate([s > 0 ? spring_span/2 : -spring_l/2, spring_front,
                   -letter_slot_d - spring_leg_l])
            cube([spring_anchor_l, -spring_front, letter_slot_d + spring_leg_l]);
}

// Where it sits in a chassis, for fit checks.
module spring_fitted() {
    translate([0, letter_slot_w/2, body_top]) spring_solid();
}

// Printed upside down, so the face that finishes flush with the deck is the one
// on the bed and everything else grows upward off it — no overhang anywhere.
rotate([180, 0, 0]) spring_solid();
