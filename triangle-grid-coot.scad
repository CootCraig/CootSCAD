use <common-functions.scad>;

// Module parameters
triangle_grid_coot_plate_width = inch(14);
triangle_grid_coot_plate_height = inch(10);
triangle_grid_coot_plate_depth = inch(0.25);
triangle_grid_coot_w_spacing = inch(0.8);
triangle_grid_coot_hole_shrinkage = 0.9; // a percentage

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

module triangle_grid_plate_coot( plate_width = triangle_grid_coot_plate_width,
                                 plate_height = triangle_grid_coot_plate_height,
                                 plate_depth = triangle_grid_coot_plate_depth,
                                 w_spacing = triangle_grid_coot_w_spacing,
                                 hole_shrinkage = triangle_grid_coot_hole_shrinkage) {

  w_to_h_ratio = sqrt(3) / 2;
  w_spacing_half = w_spacing / 2;
  h_spacing_half = (w_spacing / w_to_h_ratio) / 2;
  h_spacing_quarter = h_spacing_half / 2;
  start_shrinkage = (1 - hole_shrinkage);

  module hex_triangles_at_origin() {
    triangle_pts = [[0, 0],
                   [w_spacing_half,h_spacing_quarter],
                   [0,h_spacing_half],
                   [-w_spacing_half,h_spacing_quarter],
                   [-w_spacing_half,-h_spacing_quarter],
                   [0,-h_spacing_half],
                   [w_spacing_half,-h_spacing_quarter]];
    triangle_polys = [[0,1,2],
                      [0,2,3],
                      [0,3,4],
                      [0,4,5],
                      [0,5,6],
                      [0,6,1]];
    for (boundary_pts = triangle_polys) {
      shrink_and_extrude_triangle(pts = [triangle_pts[boundary_pts[0]],
                                         triangle_pts[boundary_pts[1]],
                                         triangle_pts[boundary_pts[2]]]);
    }
  }

  module shrink_and_extrude_triangle(pts = [[0, 0], [w_spacing_half,h_spacing_quarter], [0,h_spacing_half]]) {

    // bisector is from each point to the center of the opposite face
    bisect_0 = [pts[0], [((pts[1][0] + pts[2][0]) / 2), ((pts[1][1] + pts[2][1]) / 2)]];
    bisect_1 = [pts[1], [((pts[2][0] + pts[0][0]) / 2), ((pts[2][1] + pts[0][1]) / 2)]];
    bisect_2 = [pts[2], [((pts[0][0] + pts[1][0]) / 2), ((pts[0][1] + pts[1][1]) / 2)]];

    // linear interpolation along bisector line
    // see: https://en.wikipedia.org/wiki/Linear_interpolation
    shrink_pt_0 = [(bisect_0[0][0] + ((bisect_0[1][0] - bisect_0[0][0]) * start_shrinkage)),
                   (bisect_0[0][1] + ((bisect_0[1][1] - bisect_0[0][1]) * start_shrinkage))];

    shrink_pt_1 = [(bisect_1[0][0] + ((bisect_1[1][0] - bisect_1[0][0]) * start_shrinkage)),
                   (bisect_1[0][1] + ((bisect_1[1][1] - bisect_1[0][1]) * start_shrinkage))];

    shrink_pt_2 = [(bisect_2[0][0] + ((bisect_2[1][0] - bisect_2[0][0]) * start_shrinkage)),
                   (bisect_2[0][1] + ((bisect_2[1][1] - bisect_2[0][1]) * start_shrinkage))];

    // The shrunk triangle is extruded and cut from the rectangular base plate
    translate([0, 0, -(plate_depth / 4)]) {
      linear_extrude(height = (plate_depth * 2)) { polygon([shrink_pt_0,shrink_pt_1,shrink_pt_2]); }
    }
  }

  difference() {
    cube(size = [plate_width, plate_height, plate_depth], center = false);

    for(grid_pos_h = [0 : (6 * h_spacing_quarter) : plate_height]) {
      for(grid_pos_w = [0 : w_spacing : plate_width]) {
        translate([grid_pos_w,grid_pos_h,0]) { hex_triangles_at_origin(); }
      }
    }
  
    for(grid_pos_h = [(3 * h_spacing_quarter) : (6 * h_spacing_quarter) : plate_height + (3 * h_spacing_quarter)]) {
      for(grid_pos_w = [(w_spacing / 2) : w_spacing : (plate_width + w_spacing)]) {
        translate([grid_pos_w,grid_pos_h,0]) { hex_triangles_at_origin(); }
      }
    }
  }
}

