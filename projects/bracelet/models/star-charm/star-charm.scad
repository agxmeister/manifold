// star-charm — a five-pointed star, and the charm that goes with the
// DETACHABLE SCREW mount.
//
// It hangs on a double-ended screw (models/charm-screw) that winds into a
// threaded hole through a bracelet bar. This charm is the nut on the other
// end: a round pad on its back with a blind threaded bore, and a seat face
// that comes up tight against the screw's hex collar.
//
// It is therefore NOT interchangeable with the five ball-socket charms — a
// bar is set up for one mount or the other, by `charm_mount` in bracelet.scad.
//
// Everything else follows the house pattern exactly: a flat plate printed FACE
// DOWN on the bed, decoration ENGRAVED into that face, and the mount on the
// back pointing up while it prints. That orientation is still forced, just for
// a different reason — a threaded bore has to be bored DOWNWARDS from a face
// that prints upwards, or every groove roof in it becomes a ceiling at 57
// degrees instead of 31.
//
// WHAT CHANGED FOR THE BETTER. The ball socket needed a 7.2 mm boss with four
// slits in it and a deliberate interference fit; this is a 3.8 mm pad with a
// hole in it, there is NOTHING ON IT THAT SPRINGS, and what holds the charm on
// is a thread rather than a jaw that has to be forced past a ball. Both joints
// come apart, and the screw comes off the bracelet too, so a bar left empty is
// a plain bar with a hole in it rather than a stalk with a ball on top.
//
// WHAT CHANGED FOR THE WORSE, and it is worth knowing before printing one. A
// screw stops where the thread says it stops: the charm ends up at whatever
// angle it seats at, give or take the 45 degrees of phase slack the thread
// clearance leaves, and it is held there by friction instead of swivelling.
// The ball let a charm spin and swing freely. A star is fairly forgiving about
// this — it has five-fold symmetry and no obvious up — but a charm with a face
// on it would need the seat re-thought.
//
// THE SILHOUETTE CARRIES THE SHAPE. At 16 mm across, a star is its outline and
// almost nothing else — the points are barely 2 mm wide where anything could
// be cut into them, so every facial feature lives in the middle, which is
// exactly where the pad is on the other side and exactly where there is
// most material to cut into.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// -------------------------------------------------------------------- star
points    = 5;
star_d    = 16;    // tip to tip. `charm_reach` in bracelet.scad is this number
                   //   — keep them in step.
plate     = 2.2;   // plate thickness, as on every other charm
pad       = scr_pad_h(plate);   // the pad on the back that carries the bore.
                   //   NOT a free number: the lib sizes it so that `scr_floor`
                   //   of material is left under the bore, and `scr_floor` is
                   //   the plate's own thickness, so the face has the same
                   //   1.0 mm of cutting budget under the pad as anywhere else.
tip_round = 1.0;   // the tips are rounded to this radius, and rounded the
                   //   cheap way: the star is drawn 1 mm SHORT and then
                   //   `offset(r = tip_round)` grows it back. A pure dilation
                   //   rounds every convex corner by exactly its radius and
                   //   leaves the concave ones (the valleys) alone, so the
                   //   finished tip is `2*tip_round` = 2.0 mm wide — a real
                   //   wall, not a knife edge that meshes into slivers.
                   //
                   //   Note this is NOT the `offset(r=+a) offset(r=-a)` pair.
                   //   That is an opening, it CUTS the tips back, and the
                   //   star would come out narrower than `star_d` with no
                   //   number saying by how much.
valley_p  = 3.1;   // the valley radius OF THE DRAWN POLYGON. What matters is
                   //   where the valley ends up AFTER the dilation, which is
                   //   further out and is derived below — a valley is a
                   //   concave corner, and dilating one pushes it out along
                   //   its bisector by more than the offset radius.

star_r    = star_d/2;                       // 8.00 — finished outer radius
outer_p   = star_r - tip_round;             // 7.00 — drawn outer radius

// Where the valleys actually land. The two edges meeting at a valley are
// mirrored about the bisector; offsetting both by `tip_round` moves their
// intersection out along that bisector by tip_round/sin(angle to the bisector).
half_a    = 180/points;                                    // 36 deg
v_pt      = [valley_p*cos(half_a), valley_p*sin(half_a)];
edge      = [outer_p - v_pt[0], -v_pt[1]];                 // valley -> tip
bisect    = [cos(half_a), sin(half_a)];
edge_ang  = acos((edge[0]*bisect[0] + edge[1]*bisect[1]) / norm(edge));
valley_r  = valley_p + tip_round/sin(edge_ang);            // 4.28 — finished

assert(valley_r / star_r <= 0.60,
       str("valleys at ", valley_r/star_r,
           " of the radius — that is a cog, not a star. Lower valley_p"));
assert(star_r - valley_r >= 3.0,
       str("the points stick out only ", star_r - valley_r, " mm"));
assert(2*tip_round >= 1.2, "the star's tips are thinner than a printable wall");

// ---------------------------------------------------------------- the pad
// A round boss just big enough to wall the bore in, and no bigger — the lib
// sizes it, `scr_pad_d` = bore + 2 x `scr_wall`. It has to stay inside the
// star's INSCRIBED circle, the valley radius, because a pad poking out past an
// edge is material hanging over nothing and this project does not have those.
// Round, it clears at every orientation at once, which is just as well: a
// screwed-on charm cannot choose the angle it seats at.
pad_reach = scr_pad_d/2;                                   // 3.05
assert(pad_reach <= valley_r,
       str("the pad reaches ", pad_reach, " mm but the star's valleys are at ",
           valley_r, " — it hangs over the edge"));

// ------------------------------------------------------------------ the face
// A dished centre with a crease running out into each point. Three rules from
// lib/charm-pin.scad decide every number here:
//
//   * depth follows width at 45 degrees, so a WIDE cut needs a WIDE tip or it
//     bottoms out through the plate. The dish is 4.8 mm across and would be
//     2.4 mm deep run to a point — deeper than the plate. Its 3.6 mm flat is
//     what keeps it to 0.60, which is all the budget a 2.2 mm pad leaves.
//   * two cuts MERGE or stand 1.2 mm apart, never 0.5. The creases start at
//     r = 1.0, well inside the dish, so they merge into it. Ending them just
//     outside it is the near-miss that leaves a rib no nozzle fits.
//   * no cut may close a LOOP. Five creases radiating out of one dish close
//     nothing — the plate is still one piece of face, connected all the way
//     round the rim, which is what keeps the first layer a single island.
//
// And one rule of this charm's own: the dish sits directly under the BORE, so
// what it eats into is the bore's floor rather than the plate. That floor is
// `scr_floor`, which the lib sets equal to the plate on purpose, so the budget
// is the same 1.0 mm here as on the open face and `charm_screw_cut_max` is one
// number for the whole charm.
dish_d    = 4.8;
dish_tip  = 3.6;                            // -> 0.60 deep
crease_in = 1.0;                            // inside the dish, so they merge
crease_out= 4.0;                            // and stop before the point pinches
crease_w  = 1.6;
crease_tip= 0.8;                            // -> 0.40 deep

cut_max   = charm_screw_cut_max(plate);
dish_z    = charm_cut_depth(dish_d, dish_tip);
crease_z  = charm_cut_depth(crease_w, crease_tip);
assert(dish_z <= cut_max,
       str("the dish is ", dish_z, " mm deep and the budget is ", cut_max,
           " — widen dish_tip, or raise scr_floor in the lib"));
assert(crease_z <= cut_max, "the creases are cut too deep");
assert(crease_in + crease_w/2 < dish_d/2,
       str("the creases stop ", dish_d/2 - crease_in - crease_w/2,
           " mm short of the dish — merge them or stand them 1.2 mm off"));

// The creases must not pinch the wedge of face between two of them down to a
// sliver. The wedge is narrowest where the cutting starts, at the dish's rim.
wedge_w   = (dish_d/2) * (360/points) * PI/180 - crease_w;
assert(wedge_w >= 1.2,
       str("only ", wedge_w, " mm of face between two creases at the dish rim"));

// ...and they must not pinch the wall beside the point's edge either, which is
// what really limits how far out they can run. Perpendicular distance from the
// star's axis to the offset edge, at r = crease_out.
edge_n    = [-edge[1], edge[0]] / norm(edge);              // outward normal
crease_wall = abs((crease_out - outer_p)*edge_n[0]) + tip_round - crease_w/2;
assert(crease_wall >= 1.2,
       str("a crease leaves ", crease_wall,
           " mm of wall beside the point — pull crease_out in"));

// An odd number of points means the star is NOT square in plan: a tip is
// always opposite a valley. `star_d` is tip to tip THROUGH THE CENTRE, and the
// bounding box is smaller than that in both directions — which is the number
// `charm_reach` in bracelet.scad has to cover.
box_x = star_r * (1 + cos(180/points));                    // 14.47
box_y = 2 * star_r * sin(2*180/points);                    // 15.22
assert(max(box_x, box_y) <= 16,
       str("the star is ", max(box_x, box_y),
           " mm at its widest — raise charm_reach in bracelet.scad too"));

echo(str("star ", star_d, " mm tip to tip (box ", box_x, " x ", box_y,
         "), valleys at ", valley_r, ", ", plate, " mm plate + ", pad,
         " mm pad = ", plate + pad, " mm tall printed"));
echo(str("bore M", scr_maj, " x ", scr_pitch, ", ", scr_bore, " deep in a d",
         scr_pad_d, " x ", pad, " pad, floor ", scr_floor, " mm, ",
         scr_turns_charm, " turns of thread"));
echo(str("face: dish d", dish_d, " x ", dish_z, " deep of a ", cut_max,
         " budget, ", points, " creases at ", crease_z,
         " deep; wedge ", wedge_w, " mm, wall beside a point ", crease_wall));
echo(str("takes the ", scr_len, " mm screw; face sits ",
         scr_collar_h + pad + plate, " mm off the bar"));

// ----------------------------------------------------------------- geometry
function star_pts() = [
    for (i = [0 : 2*points - 1])
        let (a = i * 180/points, r = (i % 2 == 0) ? outer_p : valley_p)
            [r*cos(a), r*sin(a)]
];

module star_2d() offset(r = tip_round) polygon(star_pts());

module face_cuts() {
    charm_dimple(dish_d, dish_tip);
    for (i = [0 : points - 1])
        rotate([0, 0, i * 360/points])
            charm_groove([crease_in, 0], [crease_out, 0], crease_w, crease_tip);
}

module star_charm() {
    difference() {
        union() {
            linear_extrude(plate) star_2d();
            translate([0, 0, plate]) charm_screw_pad(plate);
        }
        face_cuts();
    }
}

star_charm();
