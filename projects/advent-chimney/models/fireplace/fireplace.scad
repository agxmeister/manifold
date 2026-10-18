// fireplace — the ground floor, where the surprises land.
//
// A wide brick fireplace the chimney stands on, much bigger than the
// chimney so the tall stack doesn't tip when a gate is pulled. The firebox
// behind the arch narrows into a 45° smoke funnel straight up into the
// chimney's shaft, so whatever drops lands on the hearth floor, in reach
// through the arch. A mantel shelf runs round the top, solid all over but
// for the shaft. The chimney stands at the back, its back face flush with
// the fireplace's (and the mantel's) back, so the whole calendar has one flat
// back plane to tape to a wall. The chimney starts on the shelf: a stub of brick courses whose top
// is the pocket the first section stands in, holding the day 1 gate. The
// stub is tall enough that the gate's band clears the shelf, so the gate
// pulls straight out over it.
//
// Prints upright, as it stands. The arch is round with a 45° point at its
// crown, the funnel and the mantel's underside are 45°: no support.
//
// COLOUR. `accent = false` (the default) writes the fireplace as one solid,
// for the checks and a one-colour print. `accent = true` writes it as three
// top-level objects that together are exactly that solid: the bricks, the
// mantel (corbel and shelf, from `brick_h` to `fp_h`; the chimney stub on
// it is brick again) and the hearth (everything below `hearth_h`: the slab
// in front, the firebox floor and a plinth round the body). All three are
// horizontal bands, so a print costs three filament swaps. Export with --enable=lazy-union and convert with
// tools/multicolor-3mf.py (see README).

include <../../lib/chimney.scad>

/* [Body] */
fp_w = 200;         // body width
fp_d = 100;         // body depth
fp_h = 140;         // height to the mantel's top: hearth + 12 brick courses + corbel + shelf
fp_wall = 8;        // wall thickness round the firebox

/* [Firebox and arch] */
box_w   = 130;      // firebox inside width
arch_w  = 88;       // arch opening width
arch_sp = 34;       // arch springing height, above the firebox floor
arch_band = 5;      // plain band round the arch, no mortar

/* [Mantel] */
mantel_t  = 6;      // shelf thickness
mantel_o  = 8;      // how far it overhangs the front and sides

/* [Colour] */
accent       = false;
base_color   = "firebrick";   // preview tint only; the slicer picks filaments
mantel_color = "saddlebrown";
hearth_color = "gray";
layer        = 0.2;           // colour boundaries land on multiples of this

/* [Chimney stub] */
stub_courses = 1;   // brick courses of chimney standing on the shelf, under the day 1 pocket

/* [Hearth] */
hearth_o = 18;      // hearth slab reaching forward of the body
hearth_h = 6;       // hearth height; the plinth round the body too
hearth_e = 14;      // how far it reaches past the arch on each side

floor_h = hearth_h;   // the firebox floor is flush with the hearth

// chimney placement: centred in x, back face flush with the body's back
box_d  = fp_d - 2 * fp_wall;
ch_y   = fp_d - ch_d;                      // chimney's front face
// the funnel narrows (or, at the back, widens) the firebox to the shaft at
// 45° or steeper: its height is the largest of the steps
fun_h  = max((box_w - in_w) / 2,
             abs(ch_y + wall - fp_wall),             // front
             abs((fp_d - fp_wall) - (ch_y + ch_d - wall)));  // back
arch_r = arch_w / 2;
arch_top = floor_h + arch_sp + arch_r * sqrt(2);   // crown point
box_top  = fp_h - mantel_t - fun_h - 2;   // firebox ceiling where the funnel starts
brick_h  = fp_h - mantel_t - mantel_o;    // bricks end where the corbel starts
                                          //   (and the mantel colour begins)
stub_h   = stub_courses * course;
top_h    = fp_h + stub_h;                 // the stub's top, the joint under section 1

assert(box_d >= in_d && box_w >= in_w, "firebox narrower than the chimney shaft");
assert(arch_top <= box_top + 1, "arch crown cuts into the funnel");
assert(stub_h >= pocket_d + 1, "chimney stub too short: the day 1 gate's band hits the shelf");
assert(abs((brick_h - hearth_h) / course - round((brick_h - hearth_h) / course)) < 1e-6,
       "bricks must end on a whole course");
assert(abs(hearth_h / layer - round(hearth_h / layer)) < 1e-6
       && abs(brick_h / layer - round(brick_h / layer)) < 1e-6,
       "colour boundaries must sit on layer boundaries");
assert(box_w > arch_w + 2 * 4, "arch reaches the firebox side walls");

// The arch opening's outline in its own plane: x across, y up from the
// firebox floor. Round, with the crown pointed at 45° so it prints.
module arch_2d() intersection() {
    union() {
        translate([-arch_r, 0]) square([arch_w, arch_sp]);
        translate([0, arch_sp]) hull() {
            circle(arch_r);
            rotate(45) square(arch_r);      // the 45° point
        }
    }
    translate([-arch_w, 0]) square(2 * arch_w);   // nothing below the floor
}

module fireplace_body() {
    difference() {
        union() {
            // brick body, up to the underside of the mantel's corbel
            translate([-fp_w / 2, 0, 0]) cube([fp_w, fp_d, fp_h - mantel_t]);
            // mantel: 45° corbel then the flat shelf
            hull() {
                translate([-fp_w / 2, 0, brick_h])
                    cube([fp_w, fp_d, 0.01]);
                translate([-fp_w / 2 - mantel_o, -mantel_o, fp_h - mantel_t])
                    cube([fp_w + 2 * mantel_o, fp_d + mantel_o, mantel_t]);
            }
            // the chimney's stub standing on the shelf
            translate([0, ch_y, 0]) slab(fp_h - 0.01, stub_h + 0.01) ch_rect();
            // hearth slab in front
            translate([-arch_w / 2 - hearth_e, -hearth_o, 0])
                cube([arch_w + 2 * hearth_e, hearth_o + 1, hearth_h]);
        }
        // firebox: a box, the 45° funnel, then the shaft through the mantel
        hull() {
            translate([-box_w / 2, fp_wall, floor_h]) cube([box_w, box_d, box_top - floor_h]);
            translate([0, ch_y, box_top + fun_h]) slab(0, 0.01) ch_rect(-wall);
        }
        translate([0, ch_y, 0]) slab(box_top + fun_h - 0.01, top_h - box_top - fun_h + 1)
            ch_rect(-wall);
        // the day 1 pocket under the first section, in the stub's top
        translate([0, ch_y, top_h]) pocket_cut(gate = true);
        // bricks on the stub; the course under section 1's is the other parity,
        // so the bond runs on up the chimney (kept off the shelf's top)
        intersection() {
            mortar_cut(ch_w, ch_d, fp_h, top_h, y0 = ch_y,
                       course0 = stub_courses % 2);
            translate([-ch_w, ch_y - 1, fp_h]) cube([2 * ch_w, ch_d + 2, stub_h + 1]);
        }
        // the arch, through the front wall into the firebox
        translate([0, fp_wall + 1, floor_h]) rotate([90, 0, 0])
            linear_extrude(fp_wall + 2) arch_2d();
        // bricks on the body below the mantel's corbel
        // and none on a plain band round the arch
        difference() {
            intersection() {
                mortar_cut(fp_w, fp_d, hearth_h, brick_h, top_open = false);
                translate([-fp_w, -1, hearth_h]) cube([2 * fp_w, fp_d + 2, fp_h]);
            }
            translate([0, fp_wall, floor_h]) rotate([90, 0, 0])
                linear_extrude(fp_wall + 2) offset(delta = arch_band) arch_2d();
        }
    }
}

// Everything that isn't brick: the mantel band and the hearth band.
module mantel_region() translate([-500, -500, brick_h]) cube([1000, 1000, fp_h - brick_h]);
module hearth_region() translate([-500, -500, -1]) cube([1000, 1000, hearth_h + 1]);

if (accent) {
    color(base_color)   difference()   { fireplace_body(); mantel_region(); hearth_region(); }
    color(mantel_color) intersection() { fireplace_body(); mantel_region(); }
    color(hearth_color) intersection() { fireplace_body(); hearth_region(); }
} else
    fireplace_body();
