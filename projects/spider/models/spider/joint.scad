// joint.scad — the print-in-place ring joint of the spider (renders nothing).
//
// Two links meet the way two chain links do, ring through ring:
//
//   ring one, HORIZONTAL: the inner link's front (or a socket in the body)
//          is a ring lying round a HOLE, open underneath and roofed over:
//          the link behind, a CHEEK either side, and in front a low
//          CROSSBAR from cheek to cheek.
//   ring two, VERTICAL: the outer link's rear is a flat upright TAB, round
//          on top, with a round WINDOW through it, growing straight out of
//          the link. It stands in the hole with the crossbar through its
//          window.
//
// Neither ring can open, so the links can't come apart. The hole is the tab
// swept through `swing`, so the outer link swings side to side; the tab's
// top is round about the crossbar, so it nods and twists, like a chain. As
// it nods down, the tab's far end swings back, and at `droop` its foot
// reaches the back of the hole: the droop stop.
//
// Both rings are hidden inside the inner link, like the octopus's. On a leg
// the tab is thick and runs on forward as a narrow NECK, and the inner
// link's front is a COLLAR round it, so the outer link sits partly inside
// the inner one and the two stop each other (see "the telescope" below);
// the hole's roof is a 45 deg gable along the link, cut flat just under the
// link's top. In the body (solid and tall round the joint) the tab is thin,
// straight off the first link, and the roof is a 45 deg cone.
//
// Everything prints in place, standing on the bed or self-supporting:
//   - the tab, the cheeks and the link behind stand on the bed, apart;
//   - the crossbar is the one bridge, short, across the hole, clear above
//     the tab's foot, with its edges cut off at 45 deg;
//   - the window is round, so its top is a small arch;
//   - the hole is open underneath, onto the bed; its roof leans in at
//     45 deg (on a leg, a gable with a narrow flat ridge, a short bridge;
//     in the body, a cone), and so does the mouth where the tab leaves it.
//
// Coordinates: the crossbar runs along y over the origin, bed = z 0, the
// outer link leaves along +x.

$fn = 40;

// --- fit ---
gap        = 0.5;   // clearance round the crossbar, and between pieces
                    //   standing side by side on the bed
under_gap  = 0.7;   // between the crossbar and the tab's foot under it;
                    //   more than `gap`, as the bridge sags a little
roof_gap   = 0.6;   // between the tab's top and a closed hole's ceiling
roof_min   = 1.0;   // the least of anything over a closed hole's ceiling

// --- link (the visible block) ---
link_w      = 9.4;  // link width
link_h      = 8;    // link height at the top of its dome
link_r      = link_w / 2;       // the link is round, a cylinder lying on
link_cz     = link_h - link_r;  //   the bed with its axis this high, sunk
                                //   into the bed so its underside meets it
                                //   no flatter than 45 deg

// --- tab (ring two) ---
tab_t      = 2.8;   // tab thickness
foot_h     = 1.0;   // the tab's foot, under the window
win_r      = 1.785;  // the window is round about the crossbar's axis, cut
                    //   flat top and bottom; the crossbar slides and turns in it
tip_post   = 1.4;   // the tab's far end, behind the window
top_bar    = 1.6;   // the tab's top, over the window; the top is a half
                    //   circle round the crossbar's axis
front_post = 1.2;   // the tab in front of the window, up to the link

// --- crossbar (ring one) ---
bar_w      = 2.0;   // crossbar width, along the link
bar_h      = 1.8;   // crossbar height
bar_ch     = 0.6;   // the crossbar's edges are cut off at 45 deg by this,
                    //   so it turns in a smaller round window
bar_len    = 7.2;   // crossbar length, cheek to cheek: its ends sink into
                    //   the cheeks, short of the next link's swept rear
ring_min   = 1.2;   // the least of the tab round its window
swing      = 15;    // side to side, each way: the hole is the tab swept
                    //   through this
droop      = 15;    // how far the outer link can nod down before the tab's
                    //   far end reaches the back of the hole

bar_z      = foot_h + under_gap;          // the crossbar's underside
pivot_z    = bar_z + bar_h / 2;           // the crossbar's axis height
win_top    = bar_z + bar_h + gap;         // the window's top
tab_h      = win_top + top_bar;           // tab height
win_w      = 2 * win_r;                   // window length along the link
tip_x      = -win_w / 2 - tip_post;       // the tab's far end
tab_front  = win_w / 2 + front_post;      // where the tab meets its link
tab_reach  = tab_h - pivot_z;             // the tab's top is a half circle
                                          //   round the axis, so it turns
// The droop stop. Nodding down, the tab's foot at its far end (x tip_x,
// pivot_z below the axis) swings back and up about the axis; at `droop` it
// is this far behind the axis, and the hole's back is there.
stop_r     = -tip_x * cos(droop) + pivot_z * sin(droop);
room_front = tab_front + 0.5 + gap;       // the hole's front, round the tab
room_top   = tab_h + roof_gap;            // over the tab's top
// A closed hole's ceiling is a 45 deg cone round the crossbar's upright
// axis, so it is the same however far the tab swings: z <= cone_top - r. The
// tab's top is round about the crossbar, at most tab_reach from it, and a
// point r out from the upright axis is at least r^2 - (tab_t/2)^2 from the
// axis along the tab; so the cone clears it by roof_gap if
cone_top   = pivot_z + roof_gap + sqrt(2) * norm([tab_reach, tab_t / 2]);
BIG        = 60;

assert(norm([tip_x, pivot_z]) > stop_r, "the tab's foot never reaches the droop stop");
assert(stop_r + tip_x >= gap, "the droop stop is too close behind the tab");
// Swung through `swing`, the crossbar crosses the tab obliquely: its side
// edges reach this far along the tab, at the tab's faces.
assert(norm([bar_w / 2 / cos(swing) + tab_t / 2 * tan(swing), bar_h / 2 - bar_ch]) <= win_r,
       "the window is too small for the crossbar to swing through `swing`");
win_fn     = 48;
assert(tab_reach - win_r / cos(180 / win_fn) >= ring_min, "the tab's ring round the window is too thin");
assert(-tip_x > tab_reach, "the tab's far end must reach past its round top");

link_base   = 4.45; // half-width on the bed: the round side runs straight
                    //   down to here, so the cheeks beside the swept hole
                    //   keep their thickness down to the bed (a true circle
                    //   meets the bed only 3.35 out)
// The link's section: round over the top, its sides running straight down,
// tangent to the round, to `link_base` either side on the bed. The round is
// drawn from the right side's tangent point (`link_tan`, deg round from +y
// level with the axis) over the top to the left's; `d(a)` lifts it at a.
link_tan    = atan2(-link_cz, link_base) + acos(link_r / norm([link_base, link_cz]));
link_n      = 64;   // facets round the top
function link_pts(d = function(a) 0) = concat([[link_base, 0]],
    [for (k = [0 : link_n]) let(a = link_tan + (180 - 2 * link_tan) * k / link_n)
        [0, link_cz] + (link_r + d(a)) * [cos(a), sin(a)]],
    [[-link_base, 0]]);
module link_profile() polygon(link_pts());
assert(link_cz <= link_r * sin(45) + 0.01, "the link's round underside is flatter than 45 deg at the bed");

// The link block, solid, from x0 to x1.
module link_body(x0, x1)
    translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) link_profile();

// --- ring two: the tab ------------------------------------------------------

// The tab's far end, in plan, t thick: round (a thick one only at its
// corners, so the window doesn't open out of its sides).
function end_r(t) = t <= tab_t ? t / 2 : 1.0;
module tab_end(t = tab_t)
    hull() for (s = [-1, 1]) translate([tip_x + end_r(t), s * (t / 2 - end_r(t))]) circle(end_r(t));

// The tab, in plan: its far end, on into the link.
module tab_plan(t = tab_t)
    hull() {
        tab_end(t);
        translate([0, -t / 2]) square([tab_front + 0.5, t]);
    }

// The tab with its window, t thick. Above the crossbar's axis it is trimmed
// to `tab_reach` round the axis, so it turns under anything over it. A leg's
// (`neck`) is as thick as the neck and rounded over the top like it.
module tab(t = tab_t, neck = false)
    difference() {
        intersection() {
            linear_extrude(tab_h) tab_plan(t);
            union() {
                translate([-BIG / 2, -BIG / 2, -1]) cube([BIG, BIG, pivot_z + 1]);
                translate([0, 0, pivot_z]) rotate([90, 0, 0])
                    cylinder(r = tab_reach, h = BIG, center = true, $fn = 64);
            }
            if (neck) neck_bar(-BIG / 2, BIG / 2);
        }
        rotate([90, 0, 0]) linear_extrude(BIG, center = true) window();
    }

// The window, in (x, z): round about the crossbar's axis (never smaller
// than `win_r`), cut flat at the tab's foot and over the crossbar.
module window()
    intersection() {
        translate([0, pivot_z]) circle(r = win_r / cos(180 / win_fn), $fn = win_fn);
        translate([-BIG / 2, foot_h]) square([BIG, win_top - foot_h]);
    }

// --- ring one: the hole and the crossbar ------------------------------------

// Sweeps a convex 2D shape about the origin through +-a.
module swept(a, step = 5)
    for (t = [-a : step : a - step]) hull() { rotate(t) children(); rotate(t + step) children(); }

// The tab's room, in plan: the tab, run back to the droop stop, `gap` all
// round (`g`), and on forward by `ext` (convex).
module room_plan(ext = 0, t = tab_t, g = gap)
    offset(r = g) hull() {
        translate([-(stop_r - gap) - tip_x, 0]) tab_end(t);
        tab_plan(t);
        translate([ext, 0]) tab_plan(t);
    }

// The hole: the tab's room swept through `sw`, open onto the bed, under the
// gable (a leg) or the cone (the body). In the body it runs `body_ext`
// further forward, under the body's leaning edge, so no sliver of the body
// is left between the two.
body_ext   = 1.5;
module cavity(in_body = false, sw = swing)
    if (!in_body) collar_room();
    else intersection() {
        translate([0, 0, -1]) linear_extrude(cone_top + 1) swept(sw) room_plan(body_ext);
        translate([0, 0, -1]) cylinder(r1 = cone_top + 1, r2 = 0, h = cone_top + 1, $fn = 72);
    }

// The crossbar, cheek to cheek across the hole.
module crossbar()
    translate([0, 0, pivot_z]) rotate([90, 0, 0])
        linear_extrude(bar_len, center = true) octagon(bar_w, bar_h, bar_ch);

// A w x h rectangle, centred, its corners cut off at 45 deg by c.
module octagon(w, h, c)
    polygon([[-w / 2 + c, -h / 2], [w / 2 - c, -h / 2], [w / 2, -h / 2 + c], [w / 2, h / 2 - c],
             [w / 2 - c, h / 2], [-w / 2 + c, h / 2], [-w / 2, h / 2 - c], [-w / 2, -h / 2 + c]]);

// --- the telescope: along a leg -------------------------------------------
//
// Along a leg the outer link's rear is a narrow NECK, the tab thickened to
// `neck_w` and run on forward, round over the top like a small link. The
// inner link's front is a COLLAR round it: the link runs on past the
// crossbar to its LIP at `lip_x`, hollow, and the neck goes in through a
// mouth in the lip, so the outer link sits partly inside the inner one.
// The outer link's full width starts again at its SHOULDER, `sh_x`, a short
// stretch of neck showing between the two.
//
// The links stop each other: swung through `swing` the neck lies flat
// against the side of the mouth (the mouth is the neck swept through
// `swing`, with no gap, `lip_t` deep; the room behind it has `gap` all
// round, so only the lip touches). Nodding up, the shoulder's top edge
// comes back onto the lip; nodding down, the tab's foot onto the back of
// the hole (the droop stop, as before).

neck_w     = 3.6;   // the neck's width; the tab is as thick
lip_x      = 3.0;   // the collar's lip, ahead of the crossbar
lip_t      = 1.0;   // how deep the mouth through the lip fits the neck
sh_gap     = 0.3;   // the least between the shoulder and the lip, swung
neck_r     = neck_w / 2;  // the neck's top is a half round, its sides
neck_cz    = tab_h - neck_r;  //   upright under it; as high as the tab
// The shoulder: just far enough out that, swung through `swing`, its
// corners clear the lip by `sh_gap`.
sh_x       = (lip_x + sh_gap + link_r * sin(swing)) / cos(swing);

module neck_profile()
    hull() {
        translate([0, neck_cz]) circle(neck_r, $fn = 48);
        translate([-neck_w / 2, 0]) square([neck_w, neck_cz]);
    }
module neck_bar(x0, x1)
    translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) neck_profile();

// The outer link's rear along a leg: its tab and its neck, on into the
// shoulder.
module neck()
    difference() {
        union() {
            tab(neck_w, true);
            neck_bar(0, sh_x + 1);
        }
        rotate([90, 0, 0]) linear_extrude(BIG, center = true) window();
    }

nod        = 15;    // how far the outer link can nod up, its neck's top
                    //   then up against the top of the mouth
// Nodding up, the shoulder's top edge (link_h - pivot_z over the axis, sh_x
// out) swings back; it would come onto the lip at this angle, later.
nod_sh     = let(a = sh_x, b = link_h - pivot_z, c = lip_x)
             acos(c / norm([a, b])) - atan2(b, a);  // a cos - b sin = c
assert(nod_sh > nod, "the shoulder comes onto the lip before the neck stops");

// The collar's roof is a gable in the inner link's frame, z <= gable_k - |y|,
// cut flat at `gable_flat`. gable_k clears the top of the tab and the neck
// inside the collar (x up to lip_x), swung, nodding up and down, by gap.
function neck_top(x, y) = let(r = neck_cz + sqrt(max(0, neck_r * neck_r - y * y)))
    x < 0 ? min(r, pivot_z + sqrt(max(0, tab_reach * tab_reach - x * x))) : r;
// The top of the tab and neck, in the inner link's frame, at every pose:
// [x, |y|, z]. Swung all the way it nods up only half as far (`nod_sw`):
// past that, up against the roof.
nod_sw     = 0.5;
neck_env   = [for (x = [tip_x : 0.25 : lip_x + 2], y = [-neck_w / 2 : 0.25 : neck_w / 2],
                   s = [-swing, -swing / 2, 0, swing / 2, swing],
                   n = [-droop : 2.5 : nod * (1 - (1 - nod_sw) * abs(s) / swing) + 0.01])
    let(z = neck_top(x, y) - pivot_z,
        xn = x * cos(n) - z * sin(n), zn = x * sin(n) + z * cos(n))
    [xn * cos(s) - y * sin(s), abs(xn * sin(s) + y * cos(s)), pivot_z + zn]];
gable_k    = gap * sqrt(2) + max([for (p = neck_env) if (p[0] <= lip_x - lip_t + gap) p[1] + p[2]]);
// The mouth's own ceiling, through the lip, fits the neck with no gap, so the
// neck's top comes up against it at `nod`: a gable too, cut flat.
mouth_k    = max([for (p = neck_env) if (p[0] >= lip_x - lip_t && p[0] <= lip_x) p[1] + p[2]]);
mouth_flat = max([for (p = neck_env) if (p[0] >= lip_x - lip_t && p[0] <= lip_x) p[2]]);
gable_flat = link_h - roof_min;           // the ridge, cut flat: a bridge, under 3 mm
assert(gable_k - gable_flat <= 1.5, "the collar's flat ridge is too wide a bridge");
// ... and the link's round top is still roof_min thick over the gable's slopes
assert(link_r - (gable_k - link_cz) / sqrt(2) >= roof_min, "the collar's roof is too thin over its gable");

// The hollow in the collar: the neck's room, `gap` round, swept, up to the
// lip, and the mouth through the lip, under the gable. Open underneath.
module collar_room() {
    intersection() {
        translate([0, 0, -1]) linear_extrude(BIG) intersection() {
            swept(swing, 2.5) room_plan(BIG / 4, neck_w);
            translate([-BIG / 2, -BIG / 2]) square([BIG / 2 + lip_x - lip_t, BIG]);
        }
        gable(gable_k, gable_flat);
    }
    intersection() {
        translate([0, 0, -1]) linear_extrude(BIG) swept(swing, 2.5) room_plan(BIG / 4, neck_w, 0.01);
        gable(mouth_k, mouth_flat);
    }
}
// Everything under a 45 deg gable along x, z <= k - |y|, cut flat at f.
module gable(k, f)
    translate([-BIG / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(BIG)
        polygon([[-(k + 1), -1], [k + 1, -1], [k - f, f], [-(k - f), f]]);

// --- the seam: two links butting up to each other ---------------------------
//
// In the body, where a leg's first link (or the abdomen) meets it, the outer link's rear is a flat face just behind
// where its tab joins it; the inner link's front is that face swung through
// `swing`, `gap` away, so the outer link swings freely: round in the middle,
// set back a little at the sides. Along a leg the face stands straight up,
// tops flush. In the body it stands up to `seam_up` and then leans forward
// at 45 deg, so the body's edge leans over the link (the niche, the waist).

seam_r     = tab_front - gap;  // the inner link's front, ahead of the crossbar
seam_up    = room_top - (room_front - seam_r);  // in the body, upright this
                    //   high: no higher, or the body would overhang the room's
                    //   front as a ledge with nothing under it
seam_gap   = 0.6;   // across a leaning seam (0.85 mm vertically); the
                    //   leaning overhang sags a little
seam_v     = seam_gap * sqrt(2);

// The outer link's side of a seam: everything ahead of x = r, up to `up`,
// then ahead of x = r + (z - up), `w` wide. `up` >= BIG: straight up.
module seam_zone(r, up = BIG, w = BIG)
    rotate([90, 0, 0]) linear_extrude(w, center = true)
        polygon(up >= BIG ? [[r, -1], [2 * BIG, -1], [2 * BIG, BIG], [r, BIG]]
                          : [[r, -1], [2 * BIG, -1], [2 * BIG, BIG], [r + BIG - up, BIG], [r, up]]);

// What the inner link loses ahead of its crossbar: the outer link's side of
// the seam, as wide as the link, swung through `sw` in 1 deg steps.
module seam_front(sw = swing, w = link_w + 2, up = BIG)
    for (t = [-sw : 1 : sw]) rotate([0, 0, t]) seam_zone(seam_r, up, w);

// The outer link's rear edges are bevelled at 45 deg: the bottom one up to
// the crossbar's axis (below it, the rear swings back under the inner link's
// front as the link droops), an upright seam's top one by `bevel_top` (it
// swings back as the link nods up). The tab still runs into the face between.
bevel_low  = pivot_z;
bevel_top  = 2.0;
module bevels(r, top)
    rotate([90, 0, 0]) linear_extrude(BIG, center = true) {
        polygon([[r - 1, -1], [r + bevel_low + 1, -1], [r - 1, bevel_low + 1]]);
        if (top) polygon([[r - 1, link_h - bevel_top - 1], [r + bevel_top + 2, link_h + 2],
                          [r - 1, link_h + 2]]);
    }
assert(tab_front + 0.5 > seam_r + gap + max(0, bevel_low - win_top), "the tab doesn't reach its link");

// What the outer link loses at its rear, in its own frame (its tab on the
// inner link's crossbar): everything behind its flat face, `gap` out (or
// `seam_gap` across a leaning seam), and its bevels. Its tab goes in after.
module seam_back(up = BIG)
    difference() {
        translate([-BIG, -BIG / 2, -1]) cube([2 * BIG, BIG, BIG]);
        difference() {
            seam_zone(seam_r + gap, up >= BIG ? BIG : up + gap - seam_v);
            bevels(seam_r + gap, up >= BIG);
        }
    }
// Where the outer link's rear is, at height z, beside its tab (bevels too).
function seam_rear(z, up = BIG) =
    up >= BIG ? seam_r + gap + max(0, bevel_low - z, z - (link_h - bevel_top))
              : max(seam_r + gap + max(0, bevel_low - z), seam_r - up + seam_v + z);

echo(str("telescope: shoulder ", sh_x, ", shoulder nod stop ", nod_sh, ", gable_k ", gable_k,
         ", mouth ", mouth_k, " flat ", mouth_flat));
echo(str("joint: droop stop ", stop_r, " behind the axis, tab ", tip_x, " .. ", tab_front,
         ", hole front ", room_front, ", closed ceiling cone ", cone_top, ", seam_up ", seam_up));
