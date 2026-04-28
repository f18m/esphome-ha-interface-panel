//
// OpenSCAD (https://openscad.org/)
// design file
//
// This is an adapter plate for the Waveshare 3.5'' LCD panel 
// and an Italian 503 wall/electrical box.
// The LCD panel and its electronics are designed to be press-fit 
// within an hollow box (no screws). Behind the hollow box there
// are screw holes to mount the plate on the 503 wall box.
//

// Part selection:
// - ADAPTER
// - DENT_COVER
// - OVERVIEW  (both parts above)

PART = "ADAPTER";


// ------------------
// --- Parameters ---
// ------------------
// All dimensions in millimeters
// Plate
plate_width = 116;
plate_height = 74;
plate_thickness = 4;
plate_corner_radius = 3;
// Screws
screw_spacing = 83.6;     // vertical center-to-center distance
screw_diameter = 6;       // this is the screw head max diameter
// Hollow box 
// The following are the INNER usable dimensions and they
// match almost exactly the dimensions of the WaveShare 3.5'' 
// Touch LCD; about 0.5mm have been added as buffer to allow
// the screen to enter the inner hollow box despite mechanical
// tolerances
box_inner_width = 93;
box_inner_height = 62;
box_inner_depth = 13;
box_wall_thickness = 1.5;
box_corner_radius = 4;    // rounded corners for the hollow box
// ---- Derived outer dimensions ----
box_outer_width  = box_inner_width  + 2*box_wall_thickness;
box_outer_height = box_inner_height + 2*box_wall_thickness;
box_outer_depth  = box_inner_depth  + box_wall_thickness;
// Hollow box finger dents (to extract the LCD panel easily)
dent_width = 24;          // horizontal opening width
dent_depth = 8;           // how deep into the wall
dent_corner_radius = 2;   // make the dents softer
// The top dent must be aligned with Waveshare BOOT/RST/PWR buttons
top_dent_x_offset = 16;
// Rear connector opening
rear_connector_width = 44;
rear_connector_height = 8;
rear_connector_y_offset = 24;
// Version info
text_thickness = 1;
$fn = 60; // smooth circles

// ------------------
// --- Modules ---
// ------------------

// A box with rounded vertical edges, centered at origin.
// w/h/d = full outer dimensions; r = corner radius
module rounded_box(w, h, d, r) {
    // Minkowski sum of a smaller box with a vertical cylinder
    // produces rounded vertical edges only (flat top/bottom).
    minkowski() {
        cube([w - 2*r, h - 2*r, d], center = true);
        cylinder(r = r, h = 0.001, center = true);
    }
}
// A box with rounded edges along the Y axis, centered at origin.
// w/h/d = full outer dimensions; r = corner radius
module rounded_box_y(w, h, d, r) {
    // Minkowski sum of a smaller box with a cylinder along Y
    // produces rounded edges on the top/bottom/front/back faces,
    // leaving the left/right (Y-facing) faces flat.
    minkowski() {
        cube([w - 2*r, h, d - 2*r], center = true);
        rotate([90, 0, 0])
            cylinder(r = r, h = 0.001, center = true);
    }
}

// ------------------
// --- Main model ---
// ------------------
module adapter() {
    difference() {
        union() {
            // Base plate (2D rounded rectangle extruded)
            linear_extrude(height = plate_thickness)
                offset(r = plate_corner_radius)
                    square([plate_width - 2*plate_corner_radius,
                            plate_height - 2*plate_corner_radius],
                            center = true);
            // ---- Hollow Box (Centered) ----
            translate([0, 0, box_inner_depth/2 + plate_thickness])
            difference() {
                // Outer shell — rounded vertical corners
                rounded_box(box_outer_width,
                            box_outer_height,
                            box_outer_depth,
                            box_corner_radius);
                // Inner cavity (open top) — rounded to match wall thickness
                translate([0, 0, box_wall_thickness])
                    rounded_box(box_inner_width,
                                box_inner_height,
                                box_inner_depth + 1, // ensures full subtraction
                                max(0.1, box_corner_radius - box_wall_thickness));
                
                
            }
            
            // --- Version Info ---
    //        translate([32, 0, -text_thickness])
    //            mirror([1,0,0])
    //                linear_extrude(text_thickness)
    //                    text("WaveShare adapter v2", font="Nimbus Mono PS", size=4);
        }
        // ---- Bottom Dent ----
        translate([0,
                  -box_inner_height/2 - box_wall_thickness/2,
                  plate_thickness+box_inner_depth])
            rounded_box_y(dent_width,
                        box_wall_thickness*3,
                        dent_depth*2,
                        dent_corner_radius);
        // ---- Top Dent ----
        translate([top_dent_x_offset,
                  box_inner_height/2 + box_wall_thickness/2,
                  plate_thickness+box_inner_depth])
            rounded_box_y(dent_width,
                        box_wall_thickness*3,
                        dent_depth*2,
                        dent_corner_radius);
        
        // Screw holes
        for (y = [-screw_spacing/2, screw_spacing/2]) {
            translate([y, 0, +plate_thickness])
                cylinder(d=screw_diameter, h=plate_thickness*1.9);
            translate([y, 0, -plate_thickness])
                cylinder(d=screw_diameter*0.6, h=plate_thickness*4);
        }
        
        // rear connector (for power)
        translate([0, -rear_connector_y_offset, 0])
            cube([rear_connector_width*1.2,
                  rear_connector_height*1.5,
                  plate_thickness*4],
                  center = true);
    }
}

module dent_cover() {
    // ---- Dent Cover ----
    translate([top_dent_x_offset,
              box_inner_height/2 + box_wall_thickness*4,
              plate_thickness+box_wall_thickness+dent_depth*0.8])
        rounded_box_y(dent_width,
                    box_wall_thickness*2,
                    dent_depth*0.8,
                    dent_corner_radius);

    translate([0,
              box_inner_height/2 + box_wall_thickness*4 + box_wall_thickness,
              plate_thickness+box_wall_thickness/2+box_inner_depth/2])
        cube([box_inner_width - box_corner_radius*2, box_wall_thickness, box_inner_depth], center = true);
}


// ============================================================
// PART SELECTION
// ============================================================

if      (PART == "ADAPTER")    adapter();
else if (PART == "DENT_COVER") dent_cover();
else if (PART == "OVERVIEW") {
    adapter();
    dent_cover();
}
