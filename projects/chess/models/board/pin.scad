// pin — the connector that joins two neighbouring cells. It is one of the
// two parts of the `board` model (the other is cell.scad).
//
// A flat tab: half of its length seats in each cell's groove, bridging
// the seam between them. Prints flat on the bed, no supports. The two
// insertion ends are chamfered as a lead-in so the pin starts easily.

include <connector.scad>

pin();

module pin() {
    // Hull of two boxes gives a 45-degree lead-in on the top and bottom
    // edges of both insertion (+/-Y) ends, without touching the side faces.
    hull() {
        cube([pin_width, pin_length - 2 * pin_chamfer, pin_thickness],
             center = true);
        cube([pin_width, pin_length, pin_thickness - 2 * pin_chamfer],
             center = true);
    }
}
