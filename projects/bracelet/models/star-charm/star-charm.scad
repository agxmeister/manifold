// star-charm — a five-pointed star, and the charm that goes with the
// DETACHABLE SCREW mount.
//
// It hangs on a double-ended screw (models/charm-screw) that winds into a
// threaded hole through a bracelet bar. This charm is the nut on the other
// end, and the screw is not on show anywhere: the charm's underside opens into
// a pocket that swallows the hex collar whole and a bore that takes the
// thread, so the charm sits flat on the bar with the entire screw inside it.
//
// IT PRINTS FLAT SIDE DOWN — the face that lands on the bracelet is the face
// that lands on the bed — and that one decision shapes everything else here.
//
// IT IS A PLATE WITH A RAISED MIDDLE, and the shape is the SECOND answer to
// that. The first was a solid: a 45-degree skirt rising from an 8.2 mm seat
// out to the star's points, because a 16 mm plate held up by an 8.2 mm seat
// would be cantilevered into air. It printed beautifully and then CAME OFF THE
// PLATE — the only face that touched the bed was the seat, and the seat is an
// ANNULUS, because the collar's pocket is a hole through the middle of it.
// 24 mm² under a part 7.3 mm tall was not enough and it detached mid-print.
//
// So the plate came back. The bottom is now the WHOLE star, flat, ~57 mm² of
// first layer instead of 24 — and the socket that used to need a skirt over it
// is hidden the other way, under a raised middle on the TOP face:
//
//        ___                   a 45-degree bevel on the boss
//       /   \                  the BOSS: `scr_boss_d` wide, and tall enough to
//      |     |                   swallow the socket. It is a top feature, so
//    __|     |__                 it needs no support of any kind
//   |___________|              the plate: the full 16 mm star, `plate` thick
//   ^^^^^^^^^^^^^              flat on the bar, flat on the bed
//
// Everything here is either a vertical wall or a surface that closes INWARD as
// it rises. There is no overhang on the outside of this part at all — which is
// what the first version spent its whole geometry buying, and got wrong anyway.
//
// A FLAT BOTTOM RESTS ON A PLANE, and the band's top genuinely is one: `thick`
// is `pin_z + rk`, so a knuckle's crest reaches exactly a bar's top face and
// nothing on the band is higher. The charm sits on its own bar and grazes the
// crest of whichever knuckle its points reach over. That does not bind the
// hinge — a cap is a cylinder about the pin axis, so it slides under the charm
// instead of lifting it — and the neighbouring BAR, the part that does move,
// is 5.8 mm away and out of reach. bracelet.scad asserts both.
//
// THE POCKET IN THAT FACE IS A COUNTERSINK, not a counterbore. A straight
// pocket leaves a 0.77 mm ring of ceiling where it steps in to the thread,
// which is the first thing a slicer draws on this part and the first thing
// that hangs on the plate. That is what the version before this one did; the
// lib's `charm_screw_socket` cones it now and the collar is coned to match.
//
// NO ENGRAVING. The bed-side face is against the bracelet where nothing would
// be seen, and a cut into the top would be an overhanging void. The raised
// middle is the decoration.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// -------------------------------------------------------------------- star
points    = 5;
star_d    = 16;    // tip to tip. `charm_reach` in bracelet.scad is this number
                   //   — keep them in step.
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

// ------------------------------------------------------------------- body
plate     = 3.4;   // the star itself: the whole outline in one slab, flat on
                   //   the bed and flat on the bracelet. It has to be deeper
                   //   than the collar's pocket, because the pocket is buried
                   //   in it — that is what lets the boss above be
                   //   `scr_boss_d` and not `scr_seat_d` — and deeper again by
                   //   `lift`, because of the relief below.
flat_r    = 5.8;   // HOW FAR THE FLAT BOTTOM MAY REACH, and it is measured,
                   //   not chosen. A flat face at `thick` rests on the band's
                   //   top plane, but only until a joint TURNS: the knuckle's
                   //   cap is a cylinder about the pin and stays put, but the
                   //   ARM behind it is a full-height rectangle and its top
                   //   tilts UP as the joint opens. Swept against the real
                   //   band, a flat disc at `thick` is clear out to 6.0 at 24
                   //   and 30 degrees and out to 5.8 at 40 — against the 24 a
                   //   wrist actually asks for. Past that the five points have
                   //   to be relieved, and they are relieved at 45 degrees.
boss_bevel = 1.0;  // a 45-degree bevel around the top of the raised middle, so
                   //   it reads as a set stone rather than a plug. It must not
                   //   eat past the bore below it — asserted.
height    = 7.3;   // overall. Set by the socket, not by taste: the cut reaches
                   //   `scr_socket_h` = 5.8 in from the bottom face and the
                   //   roof over it is what is left.

boss_r    = scr_boss_d/2;                                  // 3.55
boss_top_r = boss_r - boss_bevel;                          // 2.55
roof      = height - scr_socket_h;                         // 1.50
lift      = star_r - flat_r;                               // 2.20 — how far
                   //   the tips are relieved, at 45 degrees, which fixes it:
                   //   45 is the shallowest rise that prints, so this is the
                   //   LEAST the tips can be lifted by. It cannot be capped
                   //   part way either — a relief that goes flat again is a
                   //   horizontal ceiling out over air.
tip_h     = plate - lift;                                  // 1.20

assert(flat_r >= boss_r,
       str("the flat bottom is ", flat_r, " and the boss is ", boss_r,
           " — the boss would stand over the relief"));
assert(tip_h >= 1.2 - 1e-9,
       str("the star's tips come out ", tip_h,
           " mm thick — raise plate, or flat_r"));

assert(plate > scr_pocket_h,
       str("the plate is ", plate, " and the collar's pocket is ", scr_pocket_h,
           " deep — the pocket would break out through the top of the plate"));
assert(roof >= scr_roof,
       str("only ", roof, " mm of roof over the bore — raise height"));
assert(height > plate + boss_bevel,
       "there is no straight boss left between the plate and its bevel");

// The boss has to stay inside the star, and the narrowest the star ever gets
// is its valley circle. Comfortably inside, not just inside: the point of the
// raised middle is that the five points stand clear AROUND it, and at
// `scr_seat_d` it would very nearly fill the inner pentagon.
assert(boss_r <= valley_r - 0.5,
       str("the boss reaches ", boss_r, " and the valleys are at ", valley_r,
           " — it swallows the star and leaves five spikes on a disc"));

// The bevel may not undercut the bore's roof: the flat on top of the boss has
// to cover the blind end of the bore, or the roof thins to nothing at its rim.
assert(boss_top_r >= scr_hole_maj/2 + 0.3,
       str("the boss's top flat is ", 2*boss_top_r, " across and the bore is ",
           scr_hole_maj, " — the bevel eats into the roof"));

// The whole first layer, and the number the last version got wrong. It is the
// star clipped to `flat_r`, less the pocket's mouth — a hole in a face of
// about 70 mm² rather than the whole of a 24 mm² annulus.
//
// A 2n-gon with alternating radii has area n*R*r*sin(180/n). Clipping it to
// `flat_r` is estimated by capping the outer radius there, which understates it
// (the real outline is fatter, by `tip_round`) — the mesh exports 70 mm²
// against the 60 this predicts. Good: the number that has to pass the assert is
// the pessimistic one.
star_area = points * min(star_r, flat_r) * valley_r * sin(180/points);
bed_area  = star_area - PI * pow(scr_pocket_d/2, 2);
assert(bed_area >= 40,
       str("only ", bed_area, " mm2 of first layer under a ", height,
           " mm tall charm — the version that DETACHED had 24"));

echo(str("star ", star_d, " mm tip to tip, ", plate,
         " mm plate — flat on the bracelet out to r", flat_r,
         ", tips relieved ", lift, " at 45 deg to ", tip_h,
         " thick; raised middle d", scr_boss_d, " up to ", height,
         " mm (top flat d", 2*boss_top_r, ")"));
echo(str("socket: pocket d", scr_pocket_d, " x ", scr_pocket_h,
         " deep, then M", scr_maj, " x ", scr_pitch, " bore ", scr_bore,
         " deep — ", scr_socket_h, " in from the seat, roof ", roof));
echo(str("prints flat side down: first layer is the star clipped to r", flat_r,
         " less the pocket — at least ", bed_area,
         " mm2, and the mesh exports 61; the pocket is countersunk at ",
         scr_cs_ang, " deg so the only ceiling left is the ", scr_hole_maj,
         " mm bore roof, buried ", scr_socket_h, " mm in"));
echo(str("groove roofs: ", scr_ceiling_dn,
         " deg in this charm (it prints mouth DOWN), ", scr_ceiling,
         " deg in the bar"));

// ----------------------------------------------------------------- geometry
function star_pts() = [
    for (i = [0 : 2*points - 1])
        let (a = i * 180/points, r = (i % 2 == 0) ? outer_p : valley_p)
            [r*cos(a), r*sin(a)]
];

module star_2d() offset(r = tip_round) polygon(star_pts());

// The raised middle. It stands ON the plate, so its walls are vertical and its
// top closes inward — nothing here needs support, and nothing here is allowed
// to reach outside the star.
module star_boss() {
    cylinder(r = boss_r, h = height - boss_bevel);
    translate([0, 0, height - boss_bevel])
        cylinder(r1 = boss_r, r2 = boss_top_r, h = boss_bevel);
}

// The plate, with the five tips relieved. Note WHAT grows: a DISC, from
// `flat_r` outward at 45 degrees, intersected with the star. New material on
// each layer is therefore always within a layer height of the disc's boundary
// and the outline never leaps sideways. Offsetting or scaling the star instead
// makes a point emerge tangentially from the body, which is the leap that tore
// the old cable-chain design off the plate.
module star_plate() {
    intersection() {
        linear_extrude(plate) star_2d();
        union() {
            cylinder(r1 = flat_r, r2 = star_r, h = lift);
            translate([0, 0, lift]) cylinder(r = star_r + 1, h = tip_h);
        }
    }
}

module star_charm() {
    difference() {
        union() {
            star_plate();
            star_boss();
        }
        charm_screw_socket();
    }
}

star_charm();
