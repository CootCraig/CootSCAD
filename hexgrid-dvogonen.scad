// Craig Anderson
// prefix parameter variable names with hexgrid_dvogonen_
// Mon Aug 22 15:14:48 MDT 2016

// Customizable hex pattern
// Created by Kjell Kernen
// Date 22.9.2014

/*[Pattern Parameters]*/
// of the pattern in mm:
hexgrid_dvogonen_width=10;       // [10:100]

// of the pattern in mm:
hexgrid_dvogonen_length=20;      // [10:100]

// of the pattern in tens of mm:
hexgrid_dvogonen_height=5;       // [2:200]

// in tens of mm:
hexgrid_dvogonen_border_width=20;// [2:100]

// in mm:
hexgrid_dvogonen_hex_radius=2;   // [1:20]

// in tens of mm: 
hexgrid_dvogonen_hex_border_width=5; // [2:50]

/*[Hidden]*/

xborder=(hexgrid_dvogonen_border_width/10<hexgrid_dvogonen_width)?hexgrid_dvogonen_width-hexgrid_dvogonen_border_width/10:0;
yborder=(hexgrid_dvogonen_border_width/10<hexgrid_dvogonen_length)?hexgrid_dvogonen_length-hexgrid_dvogonen_border_width/10:0;

x=sqrt(3/4*hexgrid_dvogonen_hex_radius*hexgrid_dvogonen_hex_radius);
ystep=2*x;
xstep=3*hexgrid_dvogonen_hex_radius/2;

module hex(x,y)
{
	difference()
	{
		translate([x,y,-hexgrid_dvogonen_height/20]) 
			cylinder(r=(hexgrid_dvogonen_hex_radius+hexgrid_dvogonen_hex_border_width/20), h=hexgrid_dvogonen_height/10, $fn=6);	
		translate([x,y,-hexgrid_dvogonen_height/20]) 
			cylinder(r=(hexgrid_dvogonen_hex_radius-hexgrid_dvogonen_hex_border_width/20), h=hexgrid_dvogonen_height/10, $fn=6);
	}
}

//Pattern
intersection()
{
	for (xi=[0:xstep:hexgrid_dvogonen_width])
		for(yi=[0:ystep:hexgrid_dvogonen_length])
			hex(xi-hexgrid_dvogonen_width/2,((((xi/xstep)%2)==0)?0:ystep/2)+yi-hexgrid_dvogonen_length/2);
	translate([-hexgrid_dvogonen_width/2, -hexgrid_dvogonen_length/2, -hexgrid_dvogonen_height/20]) 
		cube([hexgrid_dvogonen_width,hexgrid_dvogonen_length,hexgrid_dvogonen_height/10]);
}

// Frame
difference()
{
	translate([-hexgrid_dvogonen_width/2, -hexgrid_dvogonen_length/2, -hexgrid_dvogonen_height/20]) 
		cube([hexgrid_dvogonen_width,hexgrid_dvogonen_length,hexgrid_dvogonen_height/10]);
	translate([-xborder/2, -yborder/2, -(hexgrid_dvogonen_height/20+0.1)]) 
		cube([xborder,yborder,hexgrid_dvogonen_height/10+0.2]); 
}



