use <common-functions.scad>;

// Module parameters
hexgrid_coot_plate_width = inch(14);
hexgrid_coot_plate_height = inch(10);
hexgrid_coot_plate_depth = inch(0.25);
hexgrid_coot_w_spacing = inch(0.8);
hexgrid_coot_hole_shrinkage = 0.9; // a percentage

// See:
// http://www-cs-students.stanford.edu/~amitp/gameprog.html#hex
// http://www.redblobgames.com/grids/hexagons/#basics
// http://www.redblobgames.com/grids/hexagons/
// http://playtechs.blogspot.com/2007/04/hex-grids.html

//////////////////////////////
//// http://www.redblobgames.com/grids/hexagons/#basics
//////////////////////////////

// Look at section: Geometry
// Our hex grid is oriented horizontal / pointy topped

// Look at section: Size and Spacing
// A grid w,h is defined
// Horizontal spacing of hex centers is 1w
// Vertical spacing of hex centers is (3/4)h

// Translating to a cartesion xy this is: w/h = sqrt(3)/2 ~= 0.866

module hexgrid_plate_coot( plate_width = hexgrid_coot_plate_width,
                           plate_height = hexgrid_coot_plate_height,
                           plate_depth = hexgrid_coot_plate_depth,
                           w_spacing = hexgrid_coot_w_spacing,
                           hole_shrinkage = hexgrid_coot_hole_shrinkage) {

  hole_overage = 1 + ((1 - hole_shrinkage) / 4); // a percentage
  w_to_h_ratio = sqrt(3) / 2;
  w_spacing_half = w_spacing / 2;
  h_spacing_quarter = (w_spacing / w_to_h_ratio) / 4;
  shrinkage_w_half = hole_shrinkage * w_spacing_half;
  overage_w_half = hole_overage * w_spacing_half;

  module hex_poly_at_origin() {
    difference() {
      hex_block(overage_w_half,plate_depth);
      translate([0,0,-(plate_depth/4)]) {
        hex_block(shrinkage_w_half,plate_depth*2);
      }
    }
  }

  module hex_block(w_half,block_height) {
    h_half = w_half / w_to_h_ratio;
    h_quarter = h_half / 2;
    hex_vector = [[w_half,h_quarter],
                  [0,h_half],
                  [-w_half,h_quarter],
                  [-w_half,-h_quarter],
                  [0,-h_half],
                  [w_half,-h_quarter]];
    linear_extrude(height=block_height) { polygon(hex_vector); }
  }

  for(grid_pos_h = [0 : (6 * h_spacing_quarter) : plate_height]) {
    for(grid_pos_w = [0 : w_spacing : plate_width]) {
      translate([grid_pos_w,grid_pos_h,0]) { hex_poly_at_origin(); }
    }
  }

  for(grid_pos_h = [(3 * h_spacing_quarter) : (6 * h_spacing_quarter) : plate_height + (3 * h_spacing_quarter)]) {
    for(grid_pos_w = [(w_spacing / 2) : w_spacing : (plate_width + w_spacing)]) {
      translate([grid_pos_w,grid_pos_h,0]) { hex_poly_at_origin(); }
    }
  }
}

