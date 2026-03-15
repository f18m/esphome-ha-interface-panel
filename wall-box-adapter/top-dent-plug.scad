//
// OpenSCAD design file
//
// Removable plug for the "top dent" of the
// WaveShare 503-wallbox adapter plate.
//
// The dent is a rectangular slot cut through the box wall:
//   - width  : 24 mm  (dent_width)
//   - slot depth into wall : 1.5 × 1.5 mm wall = 2.25 mm
//   - slot height (opening): 8 × 2 = 16 mm  (dent_depth × 2)
//
// Strategy
// --------
// • A tight-fitting body slides INTO the dent from outside.
// • A thin flange sits flush against the outer box face and
//   stops the plug from falling inside.
// • A finger tab protrudes outward — you pinch/pull it to
//   remove the plug without tools.
//

$fn = 60;

// ── Source dimensions (must match the main file) ──────────────
dent_width        = 24;
wall_thickness    = 1.5;
slot_wall_depth   = wall_thickness * 1.5;   // 2.25 mm
dent_depth        = 8;
slot_height       = dent_depth * 2;          // 16 mm

// ── Fit clearance ─────────────────────────────────────────────
clearance = 0.25;   // all-round gap for easy hand removal

// ── Plug body (fills the slot) ────────────────────────────────
plug_w = dent_width    - 2*clearance;   // 23.5 mm
plug_d = slot_wall_depth - clearance;   // 2.00 mm  (tight but removable)
plug_h = slot_height   - 2*clearance;   // 15.5 mm

// ── Flange (sits flush on the outside face of the box wall) ───
flange_extra_w  = 3;    // extra width each side beyond the slot
flange_extra_h  = 0;    // extra height top & bottom
flange_thickness = 1.2; // thin so it sits nearly flush

flange_w = dent_width  + 2*flange_extra_w;   // 30 mm
flange_h = slot_height + 2*flange_extra_h;   // 22 mm

// ── Finger tab ────────────────────────────────────────────────
tab_w           = 18;   // narrower than the flange — easy to grip
tab_h           = 8;    // enough surface to pinch
tab_protrusion  = 1;    // how far it sticks out from the flange
tab_thickness   = 3;    // comfortable to pull
tab_rounding    = 2;    // rounded edges for comfort

// ── Assembly ──────────────────────────────────────────────────
// Coordinate system: the plug body sits with its front face at Z=0,
// going in the +Z direction (into the slot).
// The flange is at Z=0 (outer face), the finger tab at Z < 0.

union() {

    // 1. Plug body — slides into the dent slot
    translate([-plug_w/2, -plug_h/2, 0])
        cube([plug_w, plug_h, plug_d]);

    // 2. Flange — stops the plug from going too far in
    translate([-flange_w/2, -flange_h/2, -flange_thickness])
        cube([flange_w, flange_h, flange_thickness]);

    // 3. Finger tab — rounded pull tab protruding outward
    translate([0, 0, -(flange_thickness + tab_protrusion)])
        difference() {
            // Rounded-corner tab via Minkowski
            minkowski() {
                cube([tab_w  - 2*tab_rounding,
                      tab_h  - 2*tab_rounding,
                      tab_thickness - tab_rounding],
                     center = true);
                sphere(r = tab_rounding);
            }
            // Trim anything that would overlap the flange area
            translate([0, 0, tab_protrusion/2 + tab_thickness/2])
                cube([tab_w + 1, tab_h + 1, tab_protrusion],
                     center = true);
        }
}
