// gate — the pull-out floor of one section, carrying its day number.
//
// A plate lying in the pocket on top of the section below (or of the
// fireplace, for day 1), and a wooden band across the chimney's front over
// the joint: the band stops the plate when it's home and carries the number.
// Its top edge is a pull lip to hook a finger under.
//
// The band is wood like the fireplace's mantel: the lip's front is a live
// edge wandering in by up to live_a (the 45° underside follows), V grain
// grooves with 45° roofs run along the front and round the ends, bending
// round a knot with a dimple at its heart, and two grain lines are cut in
// the lip's top. The grain stops short of the number. Every day's gate
// gets its own grain and knot, seeded by the day.
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

/* [Wood] */
wood    = true;     // a wooden band; false: a plain one
live_a  = 0.6;      // how far the lip's live front edge wanders in
grain_w = 0.8;      // width of a grain line on the lip's top
grain_d = 0.4;      // depth of every grain groove
// grain lines along the band's front, above its bottom edge (2.4 apart, so
// ridges stay >= 0.8 mm even where the knot bends them, and the bottom line
// stays >= 0.8 mm off the bed); an even count, the knot sits in the middle gap
grain_z = [2.2, 4.6, 7.0, 9.4];
// grain lines along the lip's top, y from the band's back face
grain_y = [-3.9, -1.5];
knot_r  = 2;        // knot size: the grain bends 0.6 x this round it
num_clear = 1.2;    // grain kept this far off the number

plate_w = in_w + 2 * (groove_d - gate_side);
plate_l = ch_d - rim - gate_side;   // from the front face to the pocket's back wall

assert(day >= 1 && day <= 24, "day is 1 ... 24");
assert(digit_d < band_t - 1.2, "number engraved through the band");
assert(digit_h + 2 <= band_h - lip_t - lip, "number doesn't fit under the lip");
assert(live_a < lip - 1, "live edge eats the lip");
assert(len(grain_z) % 2 == 0, "an even number of front grain lines");
assert(min(grain_z) - 0.4 - 0.6 * knot_r * 0.6 - grain_d >= 0.6, "grain too near the bed");
assert(max(grain_z) + 0.4 + 0.6 * knot_r * 0.6 + grain_d < band_h - lip_t - lip,
       "grain runs into the lip");

// ---- Wood ----------------------------------------------------------------
face_h = band_h - lip_t - lip;      // the band's flat front, below the lip
bx = ch_w / 2;                      // the band's ends, at ±bx
xs = [for (x = [-bx - 1 : 1 : bx + 1]) x];
rnd = rands(0, 1, 4, day * 7 + 1);  // this day's grain

// the knot: in the middle gap between the front grain lines, off to one
// side of the number
knot_i = len(grain_z) / 2 - 1;
knot = [(rnd[1] < 0.5 ? -1 : 1) * (18 + rnd[2] * 22),
        (grain_z[knot_i] + grain_z[knot_i + 1]) / 2 + (rnd[0] - 0.5) * 0.4];
ph = rnd[3] * 360;

// how far the live edge sits in from the straight lip front, at x
function live(x) = live_a * (0.5 + 0.3 * sin(x * 360 / 53 + ph)
                                 + 0.2 * sin(x * 360 / 23 + 2 * ph));

// A front grain line of nominal height z0, at x: a gentle wave, pushed
// aside by the knot (gently enough that neighbours never close up).
function knot_push(z0, x) =
    let(dz = z0 - knot[1], s = dz >= 0 ? 1 : -1)
    s * 0.6 * knot_r * exp(-pow((x - knot[0]) / (3 * knot_r), 2))
                     * exp(-pow(dz / (2 * knot_r), 2));
function grain_line(z0, x) =
    z0 + 0.25 * sin(x * 360 / 97 + ph + z0 * 4) + 0.15 * sin(x * 360 / 41 + z0 * 3)
       + knot_push(z0, x);

// The lip's section at x, its reach shortened by the live edge: the 45°
// underside out from the band's face, then straight up to the top.
function lip_sec(x) = let(l = lip - (wood ? live(x) : 0))
    [[-band_t + 1, face_h - 1], [-band_t - l, face_h + l], [-band_t - l, band_h],
     [-band_t + 1, band_h]];

// The band, solid: a plain board, and the lip swept across it.
// (The lip is hulled on its own: the whole section is concave, and a hull
// of it would fill the band's face up to the lip.)
module band_solid() {
    translate([-bx, -band_t, 0]) cube([ch_w, band_t, band_h]);
    if (wood)
        for (i = [1 : len(xs) - 3]) hull()
            for (x = [xs[i], xs[i + 1]])
                translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(0.01, center = true)
                    polygon(lip_sec(x));
    else
        rotate([90, 0, 90]) translate([0, 0, -bx]) linear_extrude(ch_w) polygon(lip_sec(0));
}

// The number, centred under the lip, grown by `o`, `t` deep into the band.
module number(o = 0, t = digit_d)
    translate([0, -band_t + t, face_h / 2]) rotate([90, 0, 0]) linear_extrude(t + 2)
        offset(r = o) text(str(day), size = digit_h, font = font,
                           halign = "center", valign = "center");

// Grain: V grooves along the front and round both ends, the knot's dimple,
// and the lip-top lines. All cut in; the V grooves have 45° roofs.
module wood_grain() {
    difference() {
        union() {
            for (z0 = grain_z) {
                // front, its apex grain_d in from the face
                sweep([for (x = xs) let(z = grain_line(z0, x))
                    [[x, -band_t - 1, z + grain_d + 1], [x, -band_t - 1, z - grain_d - 1],
                     [x, -band_t + grain_d, z]]]);
                // ends, level with where the front line turns the corner
                for (sx = [-1, 1]) let(z = grain_line(z0, sx * bx))
                    sweep([for (y = [-band_t - 1, 1])
                        [[sx * (bx + 1), y, z + sx * (grain_d + 1)],
                         [sx * (bx + 1), y, z - sx * (grain_d + 1)],
                         [sx * (bx - grain_d), y, z]]]);
            }
            // the knot's heart, an oval dimple the bent lines wrap round
            hull() {
                translate([knot[0], -band_t - 1, knot[1]]) rotate([-90, 0, 0])
                    scale([1.6, 1, 1]) cylinder(r = knot_r * 0.45, h = 1);
                translate([knot[0], -band_t + grain_d, knot[1]]) rotate([-90, 0, 0])
                    scale([1.6, 1, 1]) cylinder(r = knot_r * 0.2, h = 0.01);
            }
        }
        number(num_clear, digit_d + 2);
    }
    // lip top
    translate([0, 0, band_h - grain_d]) linear_extrude(grain_d + 1)
        for (y0 = grain_y)
            polygon(concat(
                [for (x = xs) [x, y0 + 0.25 * sin(x * 360 / 71 + ph + y0 * 40) + grain_w / 2]],
                [for (j = [len(xs) - 1 : -1 : 0])
                    [xs[j], y0 + 0.25 * sin(xs[j] * 360 / 71 + ph + y0 * 40) - grain_w / 2]]));
}

// In the frame of the section BELOW: plate underside at gate_z, on the floor
// of that section's pocket, front face at y = 0.
module gate() {
    translate([0, 0, gate_z]) {
        // plate
        translate([-plate_w / 2, -0.01, 0]) cube([plate_w, plate_l + 0.01, gate_t]);
        // band with the pull lip along its top, 45° underneath
        difference() {
            band_solid();
            number();
            if (wood) wood_grain();
        }
    }
}

// print pose: plate underside on the bed
translate([0, 0, -gate_z]) gate();
