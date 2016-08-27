use <common-functions.scad>;
use <triangle-grid-coot.scad>;

triangle_grid_plate_coot( plate_width = inch(20),
                          plate_height = inch(20),
                          plate_depth = inch(0.75),
                          w_spacing = inch(7),
                          hole_shrinkage = 0.8);

