// section — one of the 24 chimney sections, all identical.
//
// A brick tube 70 x 50 x 30. The pocket in its top holds the gate that is
// the NEXT section's floor: the plate lies on the pocket's floor, slides out
// through a notch in the front wall, and the ring under the section above
// closes the pocket over it. Pull the gate and whatever sat on it drops down
// the open shaft to the fireplace. (Day 1's gate is in the fireplace's top;
// the top section's pocket is filled by the cloud.)
//
// Prints upright, as it stands: the pocket and the notch are open upward and
// the ring underneath is bevelled 45°, so nothing needs support.

include <../../lib/chimney.scad>

module section() {
    difference() {
        union() {
            slab(0, ch_h) ch_rect();
            ring_solid();
        }
        // shaft
        slab(-ch_h, 3 * ch_h) ch_rect(-wall);
        translate([0, 0, ch_h]) pocket_cut(gate = true);
        mortar_cut(ch_w, ch_d, 0, ch_h, bottom_cut = mortar_d);
    }
}

section();
