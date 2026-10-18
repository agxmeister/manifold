// gate — the pull-out floor of one section, carrying its day number.
//
// A plate lying in the pocket on top of the section below (or of the
// fireplace, for day 1), and a stone band across the chimney's front over the
// joint: the band stops the plate when it's home and carries the number. Its
// top edge is a pull lip to hook a finger under.
//
// Prints as it sits in the section: plate flat on the bed, band standing
// at its front edge. Export one per day: -D day=1 ... -D day=24.

include <../../lib/chimney.scad>

/* [Day] */
day = 1;            // the number on the band, 1 (bottom) ... 24 (top)

/* [Band] */
band_h = 16;        // band height, from the plate's underside
band_t = 3;         // band thickness, standing proud of the bricks
lip    = 3;         // how far the pull lip reaches forward of the band
lip_t  = 1.5;       // lip thickness at its tip
digit_h  = 8;       // number height
digit_d  = 0.8;     // number engraving depth
font = "Liberation Sans:style=Bold";

plate_w = in_w + 2 * (groove_d - gate_side);
plate_l = ch_d - rim - gate_side;   // from the front face to the pocket's back wall

assert(day >= 1 && day <= 24, "day is 1 ... 24");
assert(digit_d < band_t - 1.2, "number engraved through the band");
assert(digit_h + 2 <= band_h - lip_t - lip, "number doesn't fit under the lip");

// In the frame of the section BELOW: plate underside at gate_z, on the floor
// of that section's pocket, front face at y = 0.
module gate(n = day) {
    translate([0, 0, gate_z]) {
        // plate
        translate([-plate_w / 2, -0.01, 0]) cube([plate_w, plate_l + 0.01, gate_t]);
        // band with the pull lip along its top, 45° underneath
        difference() {
            rotate([90, 0, 90]) translate([0, 0, -ch_w / 2])
                linear_extrude(ch_w)
                    polygon([[0, 0], [-band_t, 0],
                             [-band_t, band_h - lip_t - lip],
                             [-band_t - lip, band_h - lip_t],
                             [-band_t - lip, band_h], [0, band_h]]);
            // the number, centred under the lip
            translate([0, -band_t + digit_d, (band_h - lip_t - lip) / 2])
                rotate([90, 0, 0]) linear_extrude(digit_d + 1)
                    text(str(n), size = digit_h, font = font,
                         halign = "center", valign = "center");
        }
    }
}

// print pose: plate underside on the bed
translate([0, 0, -gate_z]) gate();
