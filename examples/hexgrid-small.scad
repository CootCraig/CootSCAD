use <common-functions.scad>;
use <hexgrid-coot.scad>;

hexgrid_plate_coot( plate_width = inch(20),
                    plate_height = inch(20),
                    plate_depth = inch(0.75),
                    w_spacing = inch(4),
                    hole_shrinkage = 0.8);

