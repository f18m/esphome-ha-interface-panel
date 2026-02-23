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


// ------------------
// --- Parameters ---
// ------------------

// All dimensions in millimeters

// Plate
plate_width = 107;
plate_height = 74;
plate_thickness = 2;

// Screws
screw_spacing = 83.6;     // vertical center-to-center distance
screw_diameter = 4.5;     // clearance for M4
corner_radius = 3;        // rounded corners

// Hollow box (INNER usable dimensions)
box_inner_width = 92.5;
box_inner_height = 61.5;
box_inner_depth = 12;
wall_thickness = 1.5;
// ---- Derived outer dimensions ----
box_outer_width  = box_inner_width  + 2*wall_thickness;
box_outer_height = box_inner_height + 2*wall_thickness;
box_outer_depth  = box_inner_depth  + wall_thickness;

// Hollow box finger dents (to extract the LCD panel easily)
dent_width = 24;     // horizontal opening width
dent_depth = 6;      // how deep into the wall
dent_height = box_inner_depth; // vertical size

// Rear connector opening
rear_connector_width = 50;
rear_connector_height = 4;
rear_connector_y_offset = 25;

$fn = 60; // smooth circles

difference() {
    union() {

        // Base plate (2D rounded rectangle extruded)
        linear_extrude(height = plate_thickness)
            offset(r = corner_radius)
                square([plate_width - 2*corner_radius,
                        plate_height - 2*corner_radius],
                        center = true);

        // ---- Hollow Box (Centered) ----
        translate([0, 0, box_inner_depth/2+plate_thickness])
        difference() {

            // Outer shell
            cube([box_outer_width,
                  box_outer_height,
                  box_outer_depth],
                  center = true);

            // Inner cavity (open top)
            translate([0, 0, wall_thickness])
                cube([box_inner_width,
                      box_inner_height,
                      box_inner_depth + 1], // ensures full subtraction
                      center = true);
            
            
            // ---- Bottom Dent ----
            translate([0,
                      -box_outer_height/2 - 0.01,
                      wall_thickness + dent_height/2])
                cube([dent_width,
                      dent_depth,
                      dent_height],
                      center = true);

            // ---- Top Dent ----
            translate([0,
                      box_outer_height/2 + 0.01,
                      wall_thickness + dent_height/2])
                cube([dent_width,
                      dent_depth,
                      dent_height],
                      center = true);
        }
    }
    
    
    // Screw holes
    for (y = [-screw_spacing/2, screw_spacing/2]) {
        translate([y,0,+plate_thickness])
            cylinder(d=screw_diameter,h=plate_thickness*1.9);
        translate([y,0,-plate_thickness])
            cylinder(d=screw_diameter*0.6,h=plate_thickness*4);
    }
    
    // rear connector (for power)
    translate([0,rear_connector_y_offset,0])
        cube([rear_connector_width*1.2,
              rear_connector_height*1.5,
              plate_thickness*4],
              center = true);
}