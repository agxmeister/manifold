// Shared board-model geometry for the puzzle chess board.
//
// The cell, the pin and the platform all `include` this file so their
// mating dimensions can never drift apart. It defines named dimensions
// only (no top-level geometry), so including it renders nothing on its
// own. Three joints live here:
//   * cell <-> pin      : the dumbbell connector (bottom-loading grooves)
//   * cell <-> platform : the round central socket
//
// ---- Cell footprint ----
cell_size     = 50;   // square tile edge (mm) — a standard tournament cell
corner_radius = 5;    // radius of the rounded vertical corners

// ---- Clearance ----
// Fit control: every mating part differs from its cavity by this much on every
// face. A POSITIVE value is clearance (part shrunk — slides in with a gap); zero
// is a nominal (interference) fit that grips via FDM over-extrusion/roughness.
// Applied ONCE per joint — the cavity is drawn at its nominal size and the
// inserted part is offset by the gap. (Do not also resize the cavity; that
// double-counts the gap.)
// connector_gap is the default (platform joint); the pin uses its own pin_gap
// so the two joints can be tuned independently.
connector_gap = 0;  // platform disc: nominal (interference) fit, same as the pin.
                    // Clearances 0.1 / 0.05 / 0.02 per side all printed with
                    // side-to-side play, so grip on the nominal size instead.
pin_gap       = 0;     // pin-joint clearance per face — nominal (interference) fit,
                       // relies on FDM over-extrusion/roughness to grip firmly
// Deliberate gap left between two joined cells. The dumbbell's waist spans
// this gap, so small height differences between adjacent battlefield tiles
// read as natural seams rather than a visible step.
cell_gap      = 2;

// ---- Dumbbell connector: cell <-> pin ----
// A flat dumbbell-shaped tab lies in a pocket that is OPEN AT THE BOTTOM of
// each cell, so pins drop straight in (or out) from underneath the board —
// even for a tile in the middle of an assembled field, where the old
// side-sliding pin could never reach. Each cell captures one bulb of the
// dumbbell; the narrow waist passes through a slot at the cell's mid-edge,
// and because the bulb is wider than that slot the two cells cannot pull
// apart. All dimensions are the nominal cavity; the pin subtracts the gap.
bulb_radius  = 7;    // radius of each dumbbell head (14 mm across) — wider heads
                     //   give more shoulder behind the neck slot, resisting pull-out
neck_width   = 7;    // width of the waist — must be < 2*bulb_radius; wider = stronger
                     //   in shear, less likely to snap at the seam
groove_depth = 10;   // bulb-chamber centre, measured in from the cell edge; pulled a
                     //   touch deeper so a solid back wall remains behind the wider bulb
pin_thickness = 6;   // vertical (Z) extent of the flat tab — doubled for a much
                     //   stiffer, harder-to-snap connector
pin_top_chamfer    = 0.6;  // decorative bevel on the pin's TOP edge, matching the
                     // platform's top rim. The pin is modelled bevel-up; rotate it upside
                     // down for printing so the bevel lands on the bed. No effect on grip.
pin_bottom_chamfer = 0;    // bevel on the pin's bottom edge (0 = square)
// Vertical slack above the seated pin. Deliberately larger than the radial
// connector_gap: the pocket must be a touch DEEPER than the pin is thick so
// the pin can be pushed all the way in (its face flush with the board bottom)
// without the pocket roof stopping it short.
groove_clearance = 0.8;
// Pocket reaches from the bed (z = 0) up past the tab, leaving the cell body
// above it as a roof — set groove_clearance clear of the pin so it fully seats.
groove_height = pin_thickness + groove_clearance;
// Bulb-centre spacing on the pin: one groove_depth into each cell plus the
// seam gap, so a bulb lands dead-centre in each cell's chamber.
bulb_offset   = groove_depth + cell_gap / 2;

// ---- Central socket: cell <-> platform ----
// A round recess in the middle of the cell holds a separately printed
// platform (print it black or white) whose top finishes flush with the
// surrounding terrain plateau — the flat stage a piece stands on.
platform_radius  = 20;   // the platform disc (40 mm across) — clears a piece base
platform_height  = 4;    // its thickness / how deep it seats
platform_chamfer = 0;    // lead-in bevel on the platform's bottom edge (0 = straight
                         // wall, full radius top-to-bottom for maximum grip surface)
platform_top_chamfer = 0.6;  // decorative bevel on the platform's TOP (visible) edge,
                             // easing the rim where the stage meets the terrain plateau
                             // (like the pin's chamfer). Does not affect the socket grip.
socket_radius = platform_radius;                  // nominal cavity (disc carries the gap)
platform_fit_radius = platform_radius - connector_gap;  // friction fit in the cell
socket_depth  = platform_height + 0.2;            // seats flush or a hair below

$fn = 48;
