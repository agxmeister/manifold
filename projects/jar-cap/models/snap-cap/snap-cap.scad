// snap-cap — a one-piece press-on cap for the jar.
//
// Three short lugs reach `grip` under the flange. To pass them the flange
// ring has to flex into a rounded triangle: pulled in at the lugs, bulging
// out between them. The skirt therefore stands `skirt_gap` clear of the
// flange all round, so the bulge has room. (The first cap left it 0.5 mm
// against a 1.0 mm grip and was too stiff to push on.) Three lugs is
// deliberate: fewer lobes make the ring easier to flex.
//
// Take it off by lifting the tab.

include <../../lib/common.scad>

/* [Fit] */
skirt_gap = 1.3;    // radial room for the flange to bulge between lugs
grip      = 0.6;    // how far each lug reaches under the flange edge
snap_gap  = 0.4;    // axial room for the flange between bead and lugs.
                    //   0.1 of squeeze instead (2026-10-03 print) made all
                    //   three lugs hard to snap under at once

/* [Lugs] */
lugs     = 3;
lug_arc  = 30;      // angular length of each lug (deg)
lug_end  = 6;       // radial taper at each end of a lug (deg)
lug_tip  = 1.2;     // lug thickness at its inner tip

/* [Body] */
skirt_h  = 6.0;     // skirt depth below the ceiling
tab_w    = 14;      // lift tab
tab_l    = 6;

skirt_ri = flange_d / 2 + skirt_gap;
lug_ri   = flange_d / 2 - grip;
reach    = skirt_ri - lug_ri;               // lug length off the wall
lug_z    = flange_bot_z - snap_gap;         // lug's upper (holding) face

assert(lug_ri > neck_d / 2 + 1, "lugs would rub the jar wall below the flange");
assert(-lug_z + lug_tip + reach + 0.5 < skirt_h, "skirt too shallow for the lugs");

// One lug: flat holding face on top, 45° lead-in underneath, both ends tapered
// so they ease past the flange instead of catching on it. Outside the flange's
// edge the holding face turns up into a 45° brace off the wall, so only the
// part the flange actually rests on prints as a flat ledge.
function lug_reach(a) = reach * max(0.02, min(1, a / lug_end, (lug_arc - a) / lug_end));
function lug_ring(a) =
    let (rw = skirt_ri + 0.4,               // sink into the wall to merge
         rt = skirt_ri - lug_reach(a),
         rg = max(rt + 0.01, flange_d / 2 + 0.2),   // where the brace starts
         zl = lug_z - lug_tip - (rw - rt))
    [ for (p = [[rw, lug_z + (rw - rg)], [rg, lug_z], [rt, lug_z],
                [rt, lug_z - lug_tip], [rw, zl]])
        [p[0] * cos(a), p[0] * sin(a), p[1]] ];

module lug() {
    n   = 30;
    pts = [ for (i = [0:n]) each lug_ring(lug_arc * i / n) ];
    m   = 5;                                // points per section
    sides = [ for (i = [0:n-1], k = [0:m-1])
        let (a = i * m, b = (i + 1) * m)
        [a + k, a + (k + 1) % m, b + (k + 1) % m, b + k] ];
    polyhedron(pts, concat(sides, [[for (k = [m-1:-1:0]) k],
                                   [for (k = [0:m-1]) n*m + k]]));
}

// Flat tongue level with the ceiling, so it prints on the bed. Sits right
// outside a lug, so pulling it lifts that lug straight off the flange. The
// first print had it between two lugs, across from the third: hard to open.
module tab() {
    translate([skirt_ri, -tab_w / 2, 0])
        hull() {
            cube([1, tab_w, top_t]);
            translate([wall + tab_l - tab_w / 4, tab_w / 4, 0])
                cylinder(r = tab_w / 4, h = top_t, $fn = 48);
            translate([wall + tab_l - tab_w / 4, 3 * tab_w / 4, 0])
                cylinder(r = tab_w / 4, h = top_t, $fn = 48);
        }
}

module snap_cap() {
    cap_shell(skirt_ri, skirt_h);
    seal_bead();
    tab();
    for (i = [0:lugs-1]) rotate(i * 360 / lugs - lug_arc / 2) lug();
}

print = true;   // -D print=false to include this file without placing a part
if (print) cap_print_pose() snap_cap();
