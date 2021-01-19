width=20;
depth=50;
height=20;
wallWidth=4;
batteryCount=20;

includePeg=true;
pegDiameter=2;
pegPoints=360;
innerFinDepth=10;
innerFinBackboneHeight=5;

removeInnerDiamond=true;
removeInnerRectangle=true;

backCutoutWidth=width*0.5;
backCutoutDepth=depth*0.75;

includeMountingPegs=true;
mountingPegHoleThickness=4;//mm
mountingPegHoleDiam=4;//mm
mountingPegThickness=3;//mm


backCutoutWidthPad = (width-backCutoutWidth)/2.0;
backCutoutDepthPad = (depth-backCutoutDepth)/2.0;

module lineup(num, space) {
  for (i = [0 : num-1])
    translate([ space*i, 0, 0 ]) children(0);
}
module mountingPeg(innerDiam, outerdiam, thickness){
    difference(){
        union(){
            cylinder(h=thickness, d=outerdiam, center=false, $fn=pegPoints);
            translate([0, -outerdiam/2, 0]){
                cube(size=[outerdiam/2, outerdiam, thickness],center=false);
            };
        };
        cylinder(h=thickness, d=innerDiam, center=false, $fn=pegPoints);
    };
}

union(){
    difference(){
        union(){
            lineup(batteryCount, width+wallWidth){
                difference(){
                    cube(size=[width+2*wallWidth,depth+2*wallWidth,height+wallWidth], center=false);
                    union(){
                        //Battery Container
                        translate([wallWidth,wallWidth,wallWidth]){
                            cube(size=[width,depth,height], center=false);
                        };
                        //Lead hole(Bottom)
                        if(includePeg){
                            translate([(width+2*wallWidth)/2,0,(height/2)+wallWidth]){
                                rotate([-90,0, 0]){
                                    cylinder(h=wallWidth, r=pegDiameter/2.0, center=false, $fn=pegPoints);
                                };
                            };
                        };
                        //Lead hole(Top)
                        if(includePeg){
                            translate([(width+2*wallWidth)/2, (depth+wallWidth), (height/2)+wallWidth]){
                                rotate([-90, 0, 0]){
                                    cylinder(h=wallWidth, r=pegDiameter/2.0, center=false, $fn=pegPoints);
                                };
                            };
                        };
                        if(removeInnerDiamond){
                            translate([wallWidth,wallWidth,0]){
                                linear_extrude(height=wallWidth){
                                    polygon(points=[
                                        [width/2, depth-backCutoutDepthPad],
                                        [width-backCutoutWidthPad, depth/2],
                                        [width/2, backCutoutDepthPad],
                                        [backCutoutWidthPad, depth/2]
                                    ]);
                                };
                            };
                        };
                        if(removeInnerRectangle){
                            translate([wallWidth,wallWidth,0]){
                                linear_extrude(height=wallWidth){
                                    polygon(points=[
                                        [width-backCutoutWidthPad, depth-backCutoutDepthPad],
                                        [width-backCutoutWidthPad, backCutoutDepthPad],
                                        [backCutoutWidthPad, backCutoutDepthPad],
                                        [backCutoutWidthPad, depth-backCutoutDepthPad]
                                    ]);
                                };
                            };
                        };

                    };
                };
            };
        };
        //Remove inner walls
        translate([wallWidth,wallWidth+innerFinDepth,wallWidth+innerFinBackboneHeight]){
            cube(size=[
                    (width+wallWidth)*batteryCount-wallWidth,
                    depth-2*innerFinDepth,
                    height-innerFinBackboneHeight
                ], center=false);
        };
    };
    if(includeMountingPegs){
        union(){
            //LowerLeft
            translate([-(mountingPegHoleDiam), mountingPegHoleDiam, 0]){
                mountingPeg(mountingPegHoleDiam, mountingPegHoleDiam+mountingPegHoleThickness, mountingPegHoleThickness);
            };
            //UpperLeft
            translate([-(mountingPegHoleDiam), depth+wallWidth, 0]){
                mountingPeg(mountingPegHoleDiam, mountingPegHoleDiam+mountingPegHoleThickness, mountingPegHoleThickness);
            };
            //LowerRight
            translate([(width+wallWidth)*batteryCount+mountingPegHoleDiam*2, mountingPegHoleDiam, 0]){
                mirror([1,0,0]){
                    mountingPeg(mountingPegHoleDiam, mountingPegHoleDiam+mountingPegHoleThickness, mountingPegHoleThickness);
                };
            };
            //UpperRight
            translate([(width+wallWidth)*batteryCount+mountingPegHoleDiam*2, depth+wallWidth, 0]){
                mirror([1,0,0]){
                    mountingPeg(mountingPegHoleDiam, mountingPegHoleDiam+mountingPegHoleThickness, mountingPegHoleThickness);
                };
            };
        };
    };
};

//2.5" drive holder
//width=13.5;
//depth=71;
//height=50;
//wallWidth=4;
//batteryCount=5;
//
//includePeg=false;
//pegDiameter=2;
//pegPoints=4;//360
//innerFinDepth=10;