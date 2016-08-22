// Customizable hex pattern
// Created by Kjell Kernen
// Date 22.9.2014

/*[Pattern Parameters]*/
// of the pattern in mm:
hexgrid_dvobonen_width=10;       // [10:100]

// of the pattern in mm:
hexgrid_dvobonen_length=20;      // [10:100]

// of the pattern in tens of mm:
hexgrid_dvobonen_height=5;       // [2:200]

// in tens of mm:
hexgrid_dvobonen_border_width=20;// [2:100]

// in mm:
hexgrid_dvobonen_hex_radius=2;   // [1:20]

// in tens of mm: 
hexgrid_dvobonen_hex_border_width=5; // [2:50]

/*[Hidden]*/

xborder=(hexgrid_dvobonen_border_width/10<hexgrid_dvobonen_width)?hexgrid_dvobonen_width-hexgrid_dvobonen_border_width/10:0;
yborder=(hexgrid_dvobonen_border_width/10<hexgrid_dvobonen_length)?hexgrid_dvobonen_length-hexgrid_dvobonen_border_width/10:0;

x=sqrt(3/4*hexgrid_dvobonen_hex_radius*hexgrid_dvobonen_hex_radius);
ystep=2*x;
xstep=3*hexgrid_dvobonen_hex_radius/2;

module hex(x,y)
{
	difference()
	{
		translate([x,y,-hexgrid_dvobonen_height/20]) 
			cylinder(r=(hexgrid_dvobonen_hex_radius+hexgrid_dvobonen_hex_border_width/20), h=hexgrid_dvobonen_height/10, $fn=6);	
		translate([x,y,-hexgrid_dvobonen_height/20]) 
			cylinder(r=(hexgrid_dvobonen_hex_radius-hexgrid_dvobonen_hex_border_width/20), h=hexgrid_dvobonen_height/10, $fn=6);
	}
}

//Pattern
intersection()
{
	for (xi=[0:xstep:hexgrid_dvobonen_width])
		for(yi=[0:ystep:hexgrid_dvobonen_length])
			hex(xi-hexgrid_dvobonen_width/2,((((xi/xstep)%2)==0)?0:ystep/2)+yi-hexgrid_dvobonen_length/2);
	translate([-hexgrid_dvobonen_width/2, -hexgrid_dvobonen_length/2, -hexgrid_dvobonen_height/20]) 
		cube([hexgrid_dvobonen_width,hexgrid_dvobonen_length,hexgrid_dvobonen_height/10]);
}

// Frame
difference()
{
	translate([-hexgrid_dvobonen_width/2, -hexgrid_dvobonen_length/2, -hexgrid_dvobonen_height/20]) 
		cube([hexgrid_dvobonen_width,hexgrid_dvobonen_length,hexgrid_dvobonen_height/10]);
	translate([-xborder/2, -yborder/2, -(hexgrid_dvobonen_height/20+0.1)]) 
		cube([xborder,yborder,hexgrid_dvobonen_height/10+0.2]); 
}



