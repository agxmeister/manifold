// Shared connector geometry for the puzzle chess board.
//
// Both the cell and the pin `include` this file so their mating
// dimensions can never drift apart. It defines named dimensions only
// (no top-level geometry), so including it renders nothing on its own.

// ---- Cell footprint ----
cell_size     = 30;   // square tile edge (mm)
corner_radius = 3;    // radius of the rounded vertical corners

// ---- Clearance ----
// Friction fit: the pin is smaller than the groove by this much on every
// sliding face, so it pushes in by hand and stays put without glue.
connector_gap = 0.15;
// Deliberate gap left between two joined cells. The pin bottoms out in
// both grooves and holds the neighbours this far apart, so small height
// differences between adjacent battlefield tiles read as natural seams
// rather than a visible step.
cell_gap      = 2;

// ---- Groove: the nominal cavity cut into each cell side ----
groove_width    = 12;   // along the cell edge
groove_depth    = 6;    // into the cell
groove_height   = 2.5;  // vertical extent of the groove
groove_center_z = 3.5;  // height of the groove centre above the bed

// ---- Pin: derived from the groove ----
// Length spans both grooves PLUS the gap: seated to the bottom of each
// groove, the pin's exposed middle sets the spacing between the cells.
pin_length    = 2 * groove_depth  + cell_gap;
pin_width     = groove_width      - 2 * connector_gap;
pin_thickness = groove_height     - 2 * connector_gap;
pin_chamfer   = 0.6;  // lead-in bevel on the two insertion ends

$fn = 48;
