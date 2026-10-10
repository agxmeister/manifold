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

// --- link (the visible block) ---
link_w      = 9.4;  // link width
link_h      = 8;    // link height at the top of its dome
link_wall_h = 4.5;  // height of the link's straight side before the dome

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
knuckle_r  = 5.5;   // the hood is a round knuckle about the crossbar, a little
                    //   wider than the link, so its walls stay thick beside
                    //   the mouth

bar_z      = foot_h + under_gap;          // the crossbar's underside
pivot_z    = bar_z + bar_h / 2;           // the crossbar's axis height
win_top    = bar_z + bar_h + gap;         // the window's top
tab_h      = win_top + top_bar;           // tab height
roof_z     = tab_h + roof_gap;            // the cavity's ceiling
tip_x      = -win_w / 2 - tip_post;       // the tab's far end
neck_x     = win_w / 2 + front_post;      // where the neck starts
tab_reach  = roof_z - pivot_z - 0.15;     // the tab's top stays this close to
                                          //   the axis, so it turns under the roof
// The knuckle's top at radius r: the link's section turned about the axis.
function knuckle_top(r) = link_wall_h + (link_h - link_wall_h)
                          * sqrt(max(1 - pow(r / knuckle_r, 2), 0));
// How far the knuckle reaches from the crossbar's axis, in any direction:
// its bed edge, or a point on its dome.
hood_reach = max([norm([knuckle_r, pivot_z]),
                  for (r = [0 : 0.1 : knuckle_r]) norm([r, knuckle_top(r) - pivot_z])]);
// The outer link's rear end is hollowed to wrap round the knuckle: a
// cylinder `gap` round it, seen from above, and a sphere clear of anything
// the knuckle has, so however the link turns about the axis they never meet.
wrap_r     = knuckle_r + gap;             // the hollow, seen from above
shoulder_x = hood_reach + gap;            // the hollow's sphere; the outer
                                          //   link's rear on its centre line
ear_t      = 1.6;                         // the hollow's corners are cut off
                                          //   square where they're this thick
rear_x     = sqrt(wrap_r * wrap_r - pow(link_w / 2 - ear_t, 2));  // there
body_x     = shoulder_x;                  // where the full link starts
tab_rear_reach = norm([tip_x, pivot_z]);  // the tab's foot at its far end,
                                          //   from the axis; it swings back
                                          //   this far as the link droops
cavity_rear = -tab_rear_reach - gap;      // the cavity's back
BIG        = 60;

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
module link_profile() profile(link_w, link_h, link_wall_h);

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

// The shoulder: the link, from its rear hollowed round the knuckle, to x1.
module shoulder(x1)
    difference() {
        link_body(rear_x, x1);
        translate([0, 0, -1]) cylinder(r = wrap_r, h = link_h + 2, $fn = 96);
        translate([0, 0, pivot_z]) sphere(shoulder_x, $fn = 96);
    }

// The outer link's inner end: tab, neck and shoulder, then the link to x1.
module link_start(x1) { tab(); neck(); shoulder(x1); }

// --- the inner link's end -------------------------------------------------

// The knuckle: the link's section turned about the crossbar's axis, a round
// bead the link runs into.
module knuckle(h = link_h, wall_h = link_wall_h)
    rotate_extrude($fn = 72) intersection() {
        profile(2 * knuckle_r, h, wall_h);
        square([knuckle_r, h]);
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
// through the knuckle as the mouth. Where the knuckle's dome sinks too low
// to roof the mouth (past `lip_r`), the mouth is cut open to the top and
// square to the knuckle, so the lips end in blunt faces, not points.
roof_min  = 1.0;    // the least of the knuckle over the cavity's roof
lip_r     = knuckle_r * sqrt(1 - pow((roof_z + roof_min - link_wall_h)
                                     / (link_h - link_wall_h), 2));
lip_angle = swing + asin((neck_w / 2 + gap) / lip_r) + 1;
module cavity() {
    translate([0, 0, -1]) linear_extrude(roof_z + 1) {
        swept(swing) offset(r = gap) tab_room_plan();
        swept(swing) offset(delta = gap) neck_plan();
    }
    translate([0, 0, -1]) linear_extrude(link_h + 2) difference() {
        polygon([[0, 0], for (t = [-lip_angle : 5 : lip_angle]) 2 * knuckle_r * [cos(t), sin(t)],
                 2 * knuckle_r * [cos(lip_angle), sin(lip_angle)]]);
        circle(r = lip_r, $fn = 72);
    }
}

// Ring one: the crossbar across the cavity, buried in the knuckle's walls.
module crossbar()
    translate([-bar_w / 2, -(knuckle_r - 0.6), bar_z]) cube([bar_w, 2 * knuckle_r - 1.2, bar_h]);

// The hood, solid: a link-shaped block from x0 (behind the joint) into the
// knuckle, `h` tall with straight sides to `wall_h` — the leg links' own
// section by default; the body's coxae are lower. Cut `cavity()` out of it
// and everything else it meets, then add `crossbar()`.
module hood_solid(x0, h = link_h, wall_h = link_wall_h) {
    translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(-x0 + 0.01) profile(link_w, h, wall_h);
    knuckle(h, wall_h);
}

echo(str("joint: hood reach ", hood_reach, ", mouth open past r ", lip_r, ", shoulder at ", shoulder_x,
         ", cavity ", cavity_rear, " .. mouth, roof at ", roof_z));
