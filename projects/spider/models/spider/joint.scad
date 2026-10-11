// joint.scad — the print-in-place hidden ring joint of the spider (renders
// nothing).
//
// Two links meet the way two chain links do, ring through ring, but the
// rings are tucked away:
//
//   hood   the outer end of the inner link (or a coxa on the body): a
//          rounded end with a CAVITY inside it and a MOUTH in front. A
//          CROSSBAR runs across the cavity, under the hood's roof, so the
//          hood and the crossbar make ring one, hidden.
//   tab    the inner end of the outer link: a flat upright tab with a WINDOW
//          through it (ring two), on a narrow NECK. The tab sits in the
//          cavity with the crossbar through its window. The neck runs out of
//          the mouth into the outer link, whose rear end is hollowed to wrap
//          round the knuckle with only a small gap.
//
// Neither ring can open, so the links can't come apart. The cavity is the
// tab and the neck swept through `swing`, so the outer link swings side to
// side; the hood's end is rounded about the crossbar and the outer link
// starts clear of it, so it also nods and twists, like a chain.
//
// Everything prints in place, standing on the bed or bridging a short gap:
//   - the tab, the neck and the hood's walls stand on the bed, apart;
//   - the crossbar is a short bridge across the cavity, clear above the
//     tab's foot;
//   - the window's top and the hood's roof are short bridges;
//   - the cavity is open underneath, onto the bed.
//
// Coordinates: the crossbar runs along y over the origin, bed = z 0, the
// outer link leaves along +x.

$fn = 40;

// --- fit ---
gap        = 0.5;   // clearance round the crossbar, and between pieces
                    //   standing side by side on the bed
under_gap  = 0.7;   // between the crossbar and the tab's foot under it;
                    //   more than `gap`, as the bridge sags a little
roof_gap   = 0.6;   // between the tab's top and the hood's roof, a bridge too
roof_min   = 1.0;   // the least of the knuckle over the cavity's roof

// --- link (the visible block) ---
link_w      = 9.4;  // link width
link_h      = 8;    // link height at the top of its dome
link_r      = link_w / 2;       // the link is round, a cylinder lying on
link_cz     = link_h - link_r;  //   the bed with its axis this high, sunk
                                //   into the bed so its underside meets it
                                //   no flatter than 45 deg

// --- tab (ring two) ---
tab_t      = 2.0;   // tab thickness
foot_h     = 1.0;   // the tab's foot, under the window
win_w      = 3.0;   // window length along the link; the crossbar slides in it
tip_post   = 1.0;   // the tab's far end, behind the window
top_bar    = 1.0;   // the tab's top, over the window
front_post = 0.8;   // the tab in front of the window, before the neck

// --- neck (the outer link's narrow end, in the mouth) ---
neck_w     = 3.0;   // neck width
neck_h     = 3.6;   // neck height; the hood's roof over it sets the nod up

// --- hood (ring one) ---
bar_w      = 1.6;   // crossbar width, along the link
bar_h      = 1.8;   // crossbar height
swing      = 25;    // side to side, each way: the cavity is the tab and the
                    //   neck swept through this
droop      = 30;    // how far the outer link can nod down before the tab's
                    //   far end rises onto the stop inside the hood
knuckle_r  = 5.5;   // the hood is a round knuckle about the crossbar, a little
                    //   wider than the link, so its walls stay thick beside
                    //   the mouth

bar_z      = foot_h + under_gap;          // the crossbar's underside
pivot_z    = bar_z + bar_h / 2;           // the crossbar's axis height
win_top    = bar_z + bar_h + gap;         // the window's top
tab_h      = win_top + top_bar;           // tab height
roof_z     = tab_h + roof_gap;            // the cavity's ceiling
knuckle_wall_h = roof_z + roof_min;       // the knuckle's straight side: its
                                          //   roof covers the mouth right out
                                          //   to its edge, over the next
                                          //   link's neck, then a low dome
tip_x      = -win_w / 2 - tip_post;       // the tab's far end
neck_x     = win_w / 2 + front_post;      // where the neck starts
tab_reach  = roof_z - pivot_z - 0.15;     // the tab's top stays this close to
                                          //   the axis, so it turns under the roof
// The knuckle's top at radius r: the link's section turned about the axis.
function knuckle_top(r) = knuckle_wall_h + (link_h - knuckle_wall_h)
                          * sqrt(max(1 - pow(r / knuckle_r, 2), 0));
// How far the knuckle reaches from the crossbar's axis, in any direction:
// its bed edge, or a point on its dome.
hood_reach = max([norm([knuckle_r, pivot_z]),
                  for (r = [0 : 0.1 : knuckle_r]) norm([r, knuckle_top(r) - pivot_z])]);
// The outer link's rear end is hollowed to wrap round the knuckle: a
// sphere clear of anything the knuckle has, so however the link turns about
// the axis they never meet, narrowing up to a circle `gap` round the knuckle
// at the top, seen from above.
wrap_r     = knuckle_r + gap;             // the hollow, seen from above
shoulder_x = hood_reach + gap;            // the hollow's sphere; the outer
                                          //   link's rear on its centre line
ear_t      = 1.6;                         // the hollow's corners are cut off
                                          //   square where they're this thick
rear_x     = sqrt(shoulder_x * shoulder_x - pow(link_w / 2 - ear_t, 2));  // there
body_x     = shoulder_x;                  // where the full link starts
tab_rear_reach = norm([tip_x, pivot_z]);  // the tab's foot at its far end,
                                          //   from the axis; it swings back
                                          //   this far as the link droops
cavity_rear = -tab_rear_reach - gap;      // the cavity's back
BIG        = 60;
// The droop stop: a ledge inside the cavity, behind the tab and `gap` clear
// of it, from `stop_z` up. As the outer link nods down, the tab's far end
// swings back and up about the crossbar; at `droop` its foot reaches the
// ledge. The tab's foot at height h (from the axis) at its far end is at
// x = tip_x cos + h sin, z = -tip_x sin + h cos once nodded down.
stop_r     = -tip_x + gap;                // the ledge, round the hood's axis
stop_h     = (-stop_r - tip_x * cos(droop)) / sin(droop);  // the tab's foot
                                          //   that meets the ledge's edge
stop_z     = pivot_z - tip_x * sin(droop) + stop_h * cos(droop);  // the ledge

assert(stop_h > -pivot_z, "the droop stop is lower than the tab's foot");
assert(neck_w > tab_t, "the neck must be wider than the tab");
assert(win_w >= bar_w / cos(swing) + tab_t * tan(swing),
       "the window is too short for the crossbar to swing through `swing`");
assert(norm([win_w / 2, tab_h - pivot_z]) <= tab_reach + 0.01,
       "the tab's top over the window would catch the roof as it nods");

// The link's cross-section in (y, z): straight sides, then a dome.
module profile(w, h, wall_h)
    intersection() {
        hull() {
            translate([-w / 2, 0]) square([w, wall_h]);
            translate([0, wall_h]) scale([w / 2, h - wall_h]) circle(1, $fn = 48);
        }
        translate([-w / 2, 0]) square([w, h]);
    }
link_base   = 4.45; // half-width on the bed: the round side runs straight
                    //   down to here, so the cavity's swept mouth leaves
                    //   >= 0.77 walls at the front corners (a true circle
                    //   meets the bed only 3.35 out, and the mouth breaks out)
module link_profile()
    intersection() {
        hull() {
            translate([0, link_cz]) circle(link_r, $fn = 64);
            translate([-link_base, 0]) square([2 * link_base, 0.01]);
        }
        translate([-link_w / 2, 0]) square([link_w, link_h]);
    }
assert(link_cz <= link_r * sin(45) + 0.01, "the link's round underside is flatter than 45 deg at the bed");

// The link block, solid, from x0 to x1.
module link_body(x0, x1)
    translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) link_profile();

// --- the outer link's end -------------------------------------------------

// The tab, in plan: a round far end out to the neck.
module tab_plan()
    hull() {
        translate([tip_x + tab_t / 2, 0]) circle(d = tab_t);
        translate([0, -tab_t / 2]) square([neck_x + 0.5, tab_t]);
    }

// The neck, in plan, as far out as the cavity has to reach.
module neck_plan() translate([neck_x, -neck_w / 2]) square([knuckle_r + 4 - neck_x, neck_w]);

// Ring two: the tab with its window. Above the crossbar's axis it is
// trimmed to `tab_reach` round the axis, so it turns under the roof.
module tab()
    difference() {
        intersection() {
            linear_extrude(tab_h) tab_plan();
            union() {
                translate([-BIG / 2, -BIG / 2, -1]) cube([BIG, BIG, pivot_z + 1]);
                translate([0, 0, pivot_z]) rotate([90, 0, 0])
                    cylinder(r = tab_reach, h = BIG, center = true, $fn = 64);
            }
        }
        translate([-win_w / 2, -BIG / 2, foot_h]) cube([win_w, BIG, win_top - foot_h]);
    }

// The neck, from the tab to the shoulder.
module neck()
    translate([neck_x - 0.5, 0, 0]) rotate([90, 0, 90])
        linear_extrude(shoulder_x - neck_x + 1) profile(neck_w, neck_h, neck_h * 0.55);

// The hollow round a knuckle, up to h: the sphere, and above it a steep
// cone in to `wrap_r` (hulled, so nothing of the link is left as a thin lip
// over the sphere).
module wrap_hollow(h)
    hull() {
        translate([0, 0, pivot_z]) sphere(shoulder_x, $fn = 96);
        translate([0, 0, pivot_z]) cylinder(r = wrap_r, h = h - pivot_z, $fn = 96);
    }

// The shoulder: the link, from its rear hollowed round the knuckle, to x1.
module shoulder(x1)
    difference() {
        link_body(rear_x, x1);
        wrap_hollow(link_h + 2);
    }

// The outer link's inner end: tab, neck and shoulder, then the link to x1.
module link_start(x1) { tab(); neck(); shoulder(x1); }

// --- the inner link's end -------------------------------------------------

// The knuckle: a round drum about the crossbar's axis, the link's height,
// with straight sides up to `knuckle_wall_h` and a low dome on top. The link
// runs into it.
module knuckle()
    rotate_extrude($fn = 72) intersection() {
        profile(2 * knuckle_r, link_h, knuckle_wall_h);
        square([knuckle_r, link_h]);
    }

// Sweeps a convex 2D shape about the origin through +-a.
module swept(a, step = 5)
    for (t = [-a : step : a - step]) hull() { rotate(t) children(); rotate(t + step) children(); }

// The tab's room, in plan: the tab, run back as far as its foot swings.
module tab_room_plan()
    hull() {
        translate([-tab_rear_reach + tab_t / 2, 0]) circle(d = tab_t);
        tab_plan();
    }

// The cavity: the tab and the neck swept through `swing`, `gap` all round,
// open onto the bed, with a flat roof (a bridge) at `roof_z`. It runs out
// through the knuckle's side as the mouth, roofed all the way, so the neck
// is hidden under the knuckle.
// The mouth's sides meet the knuckle's round side at a glancing angle;
// within `jaw_t` of it they are cut square instead, so the jaws end in
// blunt faces, not knife edges (`jaws`; a leg link has no round knuckle).
jaw_t     = 0.8;
jaw_angle = swing + asin((neck_w / 2 + gap) / (knuckle_r - jaw_t)) + 1;
module cavity(mouth_roof = roof_z, jaws = true, sw = swing) {
    translate([0, 0, -1]) linear_extrude(roof_z + 1) swept(sw) offset(r = gap) tab_room_plan();
    translate([0, 0, -1]) linear_extrude(mouth_roof + 1) {
        swept(sw) offset(delta = gap) neck_plan();
        if (jaws) difference() {
            polygon([[0, 0], for (t = [-jaw_angle : 5 : jaw_angle]) 2 * knuckle_r * [cos(t), sin(t)],
                     2 * knuckle_r * [cos(jaw_angle), sin(jaw_angle)]]);
            circle(r = knuckle_r - jaw_t, $fn = 72);
        }
    }
}

// Ring one: the crossbar across the cavity, buried in the knuckle's walls.
module crossbar()
    translate([-bar_w / 2, -(knuckle_r - 0.6), bar_z]) cube([bar_w, 2 * knuckle_r - 1.2, bar_h]);

// The droop stop: a ledge in the back of the cavity, round the tab's far end
// with `gap` to spare, from `stop_z` up to the roof. Its underside is a
// short bridge across the back of the cavity.
module droop_stop()
    intersection() {
        difference() {
            cylinder(r = knuckle_r - 0.3, h = roof_z + 0.01);
            translate([0, 0, -1]) cylinder(r = stop_r, h = roof_z + 2);
        }
        translate([-BIG, -BIG / 2, stop_z]) cube([BIG, BIG, roof_z - stop_z + 0.01]);
    }

// The hood, solid: a link block from x0 (behind the joint) into the
// knuckle. Cut `cavity()` out of it and everything else it meets, then add
// `crossbar()` and `droop_stop()`.
module hood_solid(x0) {
    link_body(x0, 0.01);
    knuckle();
}

// --- the seam: leg links butting up to each other -------------------------
//
// Along a leg, the links meet at a SEAM, tops flush: the outer link's rear
// is a flat face, standing straight up round the mouth, then leaning back
// at 45 deg; the inner link's front leans forward over it, `seam_gap`
// away. The inner link's front is that face swung through `swing`, so the
// outer link swings freely; in the middle it is round about the crossbar,
// at the sides a little set back.

neck_roof  = neck_h + roof_gap + 0.3;  // the mouth's roof on a leg
seam_r     = 4.75;  // the inner link's front, straight up to `neck_roof`
                    //   (round the mouth, whose sides are thin past this),
seam_c     = seam_r - neck_roof;  // then leaning 45 deg: x <= seam_c + z
seam_gap   = 0.6;   // across the seam (it leans, so 0.85 mm vertically);
                    //   the inner link's 45 deg overhang sags a little
seam_v     = seam_gap * sqrt(2);

// The outer link's side of the seam: everything ahead of x = max(r, c + z),
// `w` wide.
module seam_zone(r, c, w = BIG)
    rotate([90, 0, 0]) linear_extrude(w, center = true)
        polygon([[r, -1], [2 * BIG, -1], [2 * BIG, BIG], [c + BIG, BIG], [r, r - c]]);

// What the inner link loses ahead of its crossbar: the outer link's side of
// the seam, as wide as the link, swung through `swing` in 1 deg steps.
module seam_front(sw = swing, w = link_w + 2)
    for (t = [-sw : 1 : sw]) rotate([0, 0, t]) seam_zone(seam_r, seam_c, w);

// What the outer link loses at its rear, in its own frame (its tab on the
// inner link's crossbar): everything behind its flat face, `seam_gap` out
// (`gap` round the straight part). Its tab and neck go in after.
module seam_back()
    difference() {
        translate([-BIG, -BIG / 2, -1]) cube([2 * BIG, BIG, BIG]);
        seam_zone(seam_r + gap, seam_c + seam_v);
    }

echo(str("joint: droop stop at z ", stop_z, ", hood reach ", hood_reach, ", shoulder at ", shoulder_x,
         ", cavity ", cavity_rear, " .. mouth, roof at ", roof_z));
