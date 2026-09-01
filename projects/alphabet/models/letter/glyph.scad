// glyph — the shared geometry of every letter in the set. Defines named geometry
// only, so it renders nothing on its own; each letter part includes it and calls
// letter(). Every dimension lives in ../../lib/common.scad.
//
// A LETTER IS NOTHING BUT A LETTER. No plinth, no tongue, no tab — it is the
// bare glyph, and it attaches by standing in the deck groove and resting on the
// groove's floor. Anything else on it would be a distraction on a learning toy.
//
// It is a flat plate of one thickness, printed face-down: no overhang anywhere,
// no supports, and the face on the bed comes out smoothest.
//
// TWO TRAPS WITH text():
//
//  * A missing font FALLS BACK SILENTLY — no warning, no error, just different
//    letters. "Liberation Sans" was the first choice here because OpenSCAD
//    bundles it; on macOS the bundled faces are not registered with fontconfig,
//    so it rendered the fallback face instead and nothing said so. To check a
//    font resolved, render a string with it and with a deliberately bogus name
//    and compare bounding boxes: identical means it fell back.
//  * `size` is not the cap height in general. For Helvetica Bold they coincide
//    (size 44 -> 44.0 mm cap), which is why letter_size reads as a height.
//    Change the font and re-measure.

include <../../lib/common.scad>

// The letter's outline, upright in the XY plane, ready to be extruded along Z
// (which is the letter's thickness, and the print's build axis).
//
//   y = 0   is the deck surface
//   y < 0   is the part standing down inside the groove. It reaches letter_bury,
//           which is where the tapered groove closes to letter_t — NOT the
//           groove's floor. The letter wedges; it never bottoms out.
module glyph_2d(ch) {
    intersection() {
        translate([0, -letter_bury])
            scale([letter_condense, 1])
                text(ch, size = letter_size, font = letter_font,
                     halign = "center", valign = "baseline");
        // Trimmed flat at the baseline. Round letters (O, C, G, S) overshoot the
        // baseline by design, and a letter standing on a convex curve rocks —
        // there is nothing to stop it leaning. The trim costs nothing visible
        // and gives every letter a flat foot on the groove floor.
        translate([-200, -letter_bury]) square([400, 400]);
    }
}

// One letter, in its print orientation: lying on its face, thickness up Z.
module letter(ch) {
    linear_extrude(letter_t) glyph_2d(ch);
}

// Where that letter sits once it is dropped into a chassis, for fit checks.
module letter_fitted(ch) {
    translate([0, letter_t/2, body_top]) rotate([90, 0, 0]) letter(ch);
}
