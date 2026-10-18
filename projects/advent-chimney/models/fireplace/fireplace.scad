// fireplace — the ground floor, where the surprises land.
//
// A wide brick fireplace the chimney stands on, much bigger than the
// chimney so the tall stack doesn't tip when a gate is pulled. The firebox
// behind the arch narrows into a 45° smoke funnel straight up into the
// chimney's shaft, so whatever drops lands on the hearth floor, in reach
// through the arch. A mantel shelf runs round the top, solid all over but
// for the shaft: a live-edge wooden slab with grain cut into it (see Wood). The chimney stands at the back, its back face flush with
// the fireplace's (and the mantel's) back, so the whole calendar has one flat
// back plane to tape to a wall. The chimney starts on the shelf: a stub of brick courses whose top
// is the pocket the first section stands in, holding the day 1 gate. The
// stub is tall enough that the gate's band clears the shelf, so the gate
// pulls straight out over it.
//
// Prints upright, as it stands. The funnel and the mantel's underside are
// 45°. The arch is a plain semicircle on straight jambs, so the top of its
// curve is a near-flat ceiling over the opening. It's only fp_wall deep, so
// it may bridge; if not, it takes support (the user's choice, for the look).
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
fp_w = 160;         // body width
fp_d = 100;         // body depth
fp_h = 140;         // height to the mantel's top: hearth + 12 brick courses + corbel + shelf
fp_wall = 8;        // wall thickness round the firebox

/* [Firebox and arch] */
box_w   = 130;      // firebox inside width
arch_w  = 88;       // arch opening width
arch_sp = 34;       // arch springing height, above the firebox floor
arch_band = 10;     // width of the ring of arch stones round the opening
arch_stones = 13;   // stones over the semicircle (odd: a keystone at the crown)
jamb_stones = 3;    // stones up each side, below the springing

/* [Mantel] */
mantel_t  = 6;      // shelf thickness
mantel_o  = 8;      // how far it overhangs the front and sides

/* [Wood] */
wood    = true;     // a live-edge wooden mantel; false: a plain one
live_a  = 1.5;      // how far the live front edge wanders in from the straight
grain_w = 0.8;      // width of a grain line on the shelf's top
grain_d = 0.4;      // depth of every grain groove
// grain lines across the top, at these y (front to back) before they wave
grain_y = [-4.5, -1.5, 2, 5.5, 9.5, 13, 17, 20.5, 24, 28, 32.5, 36.5, 40.5,
           45, 49, 53.5, 57, 61.5, 66, 70, 74, 78.5, 82.5, 87, 91, 95];
// grain lines along the shelf's front and side edges, above its underside
grain_z = [1.9, 4.1];
// knots on the top, [x, y, r]: the grain bends round each, a dimple at its heart
// (placed so no two grain lines come closer than ~1.6 mm, centre to centre)
knots = [[-56, 11, 3], [16, 3, 2.8], [64, 66, 3.5], [-70, 47, 2.6]];

/* [Colour] */
accent       = false;
base_color   = "firebrick";   // preview tint only; the slicer picks filaments
mantel_color = "saddlebrown";
hearth_color = "gray";
layer        = 0.2;           // colour boundaries land on multiples of this

/* [Chimney stub] */
stub_courses = 1;   // brick courses of chimney standing on the shelf, under the day 1 pocket

/* [Hearth] */
hearth_o = 40;      // hearth slab reaching forward of the body (it also runs
                    //   down both sides of the body to its back)
hearth_h = 6;       // hearth height; the plinth round the body too
hearth_w = 200;     // hearth slab width (centred; the body is fp_w, so the
                    //   side runs are (hearth_w - fp_w) / 2 wide)
hearth_c = 1;       // 45° chamfer round the slab's top front and ends

/* [Flagstones] */
flags     = true;   // flagstone paving on the hearth and the firebox floor
flag_seed = 3;      // shuffles the stones
flag_max  = 34;     // stones are split until they are about this size (mm)
flag_skew = 6;      // how far a joint leans from square, end to end (mm)
flag_gd   = 0.8;    // joint depth; a 45° V, so 2 x this wide at the top
flag_drop = [0, 0.2, 0.4];   // stone tops sit this far below hearth_h, at random

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
arch_top = floor_h + arch_sp + arch_r;   // crown
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
assert(hearth_w >= fp_w + 2 * 12, "hearth's side runs too narrow for flagstones");
assert(abs(max(flag_drop) / layer - round(max(flag_drop) / layer)) < 1e-6,
       "flagstone drops must be whole layers");

// The arch opening's outline in its own plane: x across, y up from the
// firebox floor. Straight jambs up to the springing, then a semicircle.
module arch_2d() intersection() {
    union() {
        translate([-arch_r, 0]) square([arch_w, arch_sp]);
        translate([0, arch_sp]) circle(arch_r, $fn = 96);
    }
    translate([-arch_w, 0]) square(2 * arch_w);   // nothing below the floor
}

// The ring of arch stones' joints, as thin centrelines in arch_2d's plane:
// the line between the ring and the wall bricks, radial joints round the
// semicircle, flat joints up the jambs. arch_joints() grows them into
// V grooves.
module arch_joint_lines() {
    t = 0.1;
    intersection() {
        union() {
            // the ring's outer edge
            difference() {
                offset(delta = arch_band + t / 2) arch_2d();
                offset(delta = arch_band - t / 2) arch_2d();
            }
            // radial joints between the voussoirs
            for (i = [1:arch_stones - 1])
                translate([0, arch_sp]) rotate(i * 180 / arch_stones)
                    translate([arch_r - 1, -t / 2]) square([arch_band + 1, t]);
            // flat joints on the jambs, the springing included
            for (i = [1:jamb_stones], sx = [-1, 1])
                translate([sx > 0 ? arch_r - 1 : -arch_r - arch_band,
                           i * arch_sp / jamb_stones - t / 2])
                    square([arch_band + 1, t]);
        }
        // not into the hearth below the firebox floor
        translate([-fp_w, 1]) square(2 * fp_w);
    }
}

// The joints cut into the front face (y = 0, outside -y): each line swept
// by a 45° cone, so every groove is a V whose sides print at 45° whichever
// way it runs round the arch.
module arch_joints()
    minkowski() {
        rotate([90, 0, 0]) linear_extrude(0.01) arch_joint_lines();
        hull() {
            rotate([90, 0, 0]) cylinder(h = 1, r = mortar_d, $fn = 8);   // out past the face
            rotate([-90, 0, 0]) cylinder(h = mortar_d, r1 = mortar_d, r2 = 0, $fn = 8);
        }
    }

// ---- Flagstones ----------------------------------------------------------
// The hearth is paved with big irregular flagstones, as in a real stone
// hearth. The slab, and the firebox floor behind the arch, are each split in
// two by a slightly skewed cut across their longer way, and each half again,
// until the stones are about flag_max: quads of uneven size whose joints
// meet in T's and never run straight across. Each stone's top sits a little
// lower or higher than its neighbours'. The joints are 45° V grooves cut
// into the top, so like every other mark on the paving they are open upward;
// where a joint reaches the slab's front or an end it runs down the face as
// a vertical V.

hw  = hearth_w / 2;
fy0 = -hearth_o;   // the slab's front

function lerp(p, q, t) = p + (q - p) * t;
function rnd(seed, i) = rands(0, 1, 1, seed * 7 + i)[0];

// Split the quad [a, b, c, d] (a -> b and d -> c the sides a cut crosses)
// until it is about flag_max. A long piece is cut across its length; a
// near-square one either way. The cut leans by up to flag_skew. Returns a
// list of ["q", quad] stones and ["s", p, q] cuts.
function flag_split(qd, seed, depth = 0) =
    let(a = qd[0], b = qd[1], c = qd[2], d = qd[3],
        lab = (norm(b - a) + norm(c - d)) / 2, lbc = (norm(c - b) + norm(d - a)) / 2,
        turn = lbc > lab * (rnd(seed, 3) < 0.5 ? 1.5 : 1 / 1.5))
    turn && depth >= 0 ? flag_split([b, c, d, a], seed, -depth - 1)   // turn once
    : let(dp = depth < 0 ? -depth - 1 : depth)
      (max(lab, lbc) < flag_max * (0.8 + 0.5 * rnd(seed, 0)) || dp > 8) ? [["q", qd]]
    : let(t = 0.35 + 0.3 * rnd(seed, 1),
          p = lerp(a, b, t),
          q = lerp(d, c, t + (2 * rnd(seed, 2) - 1) * flag_skew / norm(c - d)))
      concat([["s", p, q]],
             flag_split([a, p, q, d], seed * 2 + 1, dp + 1),
             flag_split([p, b, c, q], seed * 2 + 2, dp + 1));

flag_back = fp_d - fp_wall;
bx = fp_w / 2;   // the body's sides
flag_items = concat(
    // the front, between the body's sides, and a run down each side to the back
    flag_split([[-bx, fy0], [bx, fy0], [bx, 0], [-bx, 0]], flag_seed),
    flag_split([[bx, fy0], [hw, fy0], [hw, fp_d], [bx, fp_d]], flag_seed + 2000),
    flag_split([[-hw, fy0], [-bx, fy0], [-bx, fp_d], [-hw, fp_d]], flag_seed + 3000),
    [for (sx = [-1, 1]) ["s", [sx * bx, fy0], [sx * bx, 0]]],   // front to side runs
    flag_split([[-box_w / 2, 0], [box_w / 2, 0], [box_w / 2, flag_back], [-box_w / 2, flag_back]],
               flag_seed + 1000),
    [["s", [-arch_r - 1, 0], [arch_r + 1, 0]]]);   // slab to firebox, under the arch

// The paved floor, in plan: the slab in front, the arch opening, the firebox.
module paved_2d() union() {
    translate([-hw, fy0]) square([hearth_w, -fy0 + 0.01]);
    for (sx = [-1, 1]) translate([sx > 0 ? bx - 0.01 : -hw, 0]) square([hw - bx + 0.01, fp_d]);
    translate([-arch_r, -1]) square([arch_w, fp_wall + 2]);
    translate([-box_w / 2, fp_wall]) square([box_w, box_d]);
}

// A V joint from p to q on the paving's top (z = hearth_h). Its ends lie on
// the centreline of the joint it meets, so a T leaves no tick past it.
module flag_joint(p, q) hull()
    for (e = [p, q]) translate([e[0], e[1], hearth_h - flag_gd])
        cylinder(h = flag_gd + 1, r1 = 0, r2 = flag_gd + 1, $fn = 4);

// A V joint down a vertical face, at (x, y), the diamond's point into it.
module face_joint(x, y)
    translate([x, y, -1]) rotate(45) cylinder(h = hearth_h + 2, r = flag_gd * sqrt(2), $fn = 4);

module flagstones() {
    // stones' tops dropped below hearth_h, kept to the paved floor
    intersection() {
        translate([0, 0, hearth_h - max(flag_drop)]) linear_extrude(1 + max(flag_drop))
            paved_2d();
        union() for (i = [0 : len(flag_items) - 1]) let(it = flag_items[i])
            if (it[0] == "q") let(dz = flag_drop[floor(rnd(flag_seed + 500, i) * len(flag_drop) * 0.999)])
                if (dz > 0) translate([0, 0, hearth_h - dz]) linear_extrude(2) polygon(it[1]);
    }
    // the joints
    intersection() {
        translate([0, 0, -1]) linear_extrude(hearth_h + 2) paved_2d();
        union() for (it = flag_items) if (it[0] == "s") flag_joint(it[1], it[2]);
    }
    // joints running down the slab's front and ends
    for (it = flag_items) if (it[0] == "s") for (e = [it[1], it[2]]) {
        if (abs(e[1] - fy0) < 1e-6) face_joint(e[0], fy0);
        if (abs(abs(e[0]) - hw) < 1e-6 && e[1] < fp_d - 1) face_joint(e[0], e[1]);
    }
}

// ---- Wood ----------------------------------------------------------------
// The mantel is a live-edge slab: its front edge wanders in from the
// straight by up to live_a (never out, so the footprint stays the same), the
// corbel under it following at 45°. Grain lines run along the slab: grooves
// in its top, bending round a few knots, and V grooves (45° roofs) along the
// front and side edges. Everything is cut in, so nothing needs support.

shelf_z = fp_h - mantel_t;          // the shelf's underside
mx      = fp_w / 2 + mantel_o;      // the shelf's ends, at ±mx

// how far the live edge sits in from the straight front, at x
function live(x) = live_a * (0.5 + 0.3 * sin(x * 360 / 53 + 20)
                                 + 0.2 * sin(x * 360 / 23 + 70));
function front_y(x) = -mantel_o + live(x);

// How far the knots push a grain line of nominal y0 aside, at x: most at
// the knot, less further along and for lines that pass further off. The
// push never overtakes a line's distance, so lines don't cross.
function knot_push(y0, x) =
    let(p = [for (k = knots)
        let(dy = y0 - k[1], s = dy >= 0 ? 1 : -1)
        s * 1.4 * k[2] * exp(-pow((x - k[0]) / (3 * k[2]), 2))
                       * exp(-pow(dy / (2 * k[2]), 2))])
    p * [for (k = knots) 1];
function grain_line(y0, x) =
    y0 + 0.8 * sin(x * 360 / 97 + y0 * 2) + 0.5 * sin(x * 360 / 41 + y0 * 1.5)
       + knot_push(y0, x);

xs = [for (x = [-mx - 1 : 1 : mx + 1]) x];

// Behind the live front: a solid whose front is the shelf's live edge and,
// below the shelf, the corbel's 45° face. The mantel is cut by it.
module live_cutter() union() {
    zb = brick_h - 1;
    for (i = [0 : len(xs) - 2]) hull()
        for (x = [xs[i], xs[i + 1]]) let(yf = front_y(x))
            translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(0.01)
                polygon([[yf, fp_h + 1], [yf, shelf_z], [yf + shelf_z - zb, zb],
                         [fp_d + 1, zb], [fp_d + 1, fp_h + 1]]);
}

// The grain line at height zg on the front edge, as a V groove: its apex
// grain_d in from the live face, both sides at 45°.
function front_groove_z(zg, x) = shelf_z + zg + 0.5 * sin(x * 360 / 61 + zg * 50);
module front_groove(zg)
    sweep([for (x = xs) let(yf = front_y(x), z = front_groove_z(zg, x))
        [[x, yf - 1, z + grain_d + 1], [x, yf - 1, z - grain_d - 1], [x, yf + grain_d, z]]]);

// The same on an end of the shelf, `sx` = -1 or 1, running front to back.
module side_groove(zg, sx) {
    ys = [for (y = [-mantel_o - 1 : 1 : fp_d + 1]) y];
    sweep([for (y = ys) let(z = shelf_z + zg + 0.5 * sin(y * 360 / 47 + zg * 80 + sx * 90))
        [[sx * (mx + 1), y, z + sx * (grain_d + 1)], [sx * (mx + 1), y, z - sx * (grain_d + 1)],
         [sx * (mx - grain_d), y, z]]]);
}

// The grain on the top, in plan: the lines and the knots' hearts,
// kept off the live edge and away from the chimney stub.
module top_grain_2d() difference() {
    intersection() {
        union() {
            for (y0 = grain_y)
                polygon(concat(
                    [for (x = xs) [x, grain_line(y0, x) + grain_w / 2]],
                    [for (x = [len(xs) - 1 : -1 : 0]) [xs[x], grain_line(y0, xs[x]) - grain_w / 2]]));
            // each knot's heart, an oval dimple the bent lines wrap round
            for (k = knots) translate([k[0], k[1]]) scale([1.6, 1]) circle(k[2] * 0.45);
        }
        // inside the shelf, clear of the live edge and the ends
        polygon(concat([[mx - 1, fp_d - 1], [-mx + 1, fp_d - 1]],
                       [for (x = [-mx + 1 : 1 : mx - 1]) [x, front_y(x) + 1]]));
    }
    translate([0, ch_y]) ch_rect(0.5);
}

module wood_grain() {
    translate([0, 0, fp_h - grain_d]) linear_extrude(grain_d + 1) top_grain_2d();
    for (zg = grain_z) {
        front_groove(zg);
        for (sx = [-1, 1]) side_groove(zg, sx);
    }
}

module fireplace_body() {
    difference() {
        union() {
            // brick body, up to the underside of the mantel's corbel
            translate([-fp_w / 2, 0, 0]) cube([fp_w, fp_d, fp_h - mantel_t]);
            // mantel: 45° corbel then the flat shelf, its front a live edge
            intersection() {
                hull() {
                    translate([-fp_w / 2, 0, brick_h])
                        cube([fp_w, fp_d, 0.01]);
                    translate([-fp_w / 2 - mantel_o, -mantel_o, fp_h - mantel_t])
                        cube([fp_w + 2 * mantel_o, fp_d + mantel_o, mantel_t]);
                }
                if (wood) live_cutter(); else translate([-500, -500, 0]) cube(1000);
            }
            // the chimney's stub standing on the shelf
            translate([0, ch_y, 0]) slab(fp_h - 0.01, stub_h + 0.01) ch_rect();
            // hearth slab in front and down both sides to the back plane,
            // its top front and end edges chamfered at 45° (the back stays flush)
            hull() {
                translate([-hw, -hearth_o, 0]) cube([hearth_w, fp_d + hearth_o, hearth_h - hearth_c]);
                translate([-hw + hearth_c, -hearth_o + hearth_c, 0])
                    cube([hearth_w - 2 * hearth_c, fp_d + hearth_o - hearth_c, hearth_h]);
            }
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
        // bricks on the body below the mantel's corbel, stopping at the
        // ring of arch stones, which has joints of its own
        difference() {
            intersection() {
                mortar_cut(fp_w, fp_d, hearth_h, brick_h, top_open = false);
                translate([-fp_w, -1, hearth_h]) cube([2 * fp_w, fp_d + 2, fp_h]);
            }
            translate([0, fp_wall, floor_h]) rotate([90, 0, 0])
                linear_extrude(fp_wall + 2) offset(delta = arch_band) arch_2d();
        }
        translate([0, 0, floor_h]) arch_joints();
        if (wood) wood_grain();
        if (flags) flagstones();
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
