/*
Zero-Clause BSD

Copyright (C) 2025 by KAWABATA, Kazumichi

Permission to use, copy, modify, and/or distribute this software for any purpose
with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.
*/

include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/joiners.scad>

// (Quality)
$fn = 128;
//(The slop amount to make printed items fit closely)
$slop = 0.1;

// Size

width  = 150; // 箱の横幅
height = 100; // 箱の深さ
depth  = 92;  // 箱の奥行き

// (Distance between joint and box edge)
xshift = 10; // 箱の端からジョイントを何mm寄せるか

/* [Hidden] */

clamp_w = 40; // クランプ部分の横幅

screw_dia=20;    // ネジ径
screw_th=3;      // ネジのミゾ幅
screw_length=40; // ネジの長さ

joint_width=30;
joint_slide=30;
joint_depth=5;
joint_angle=15;

wall_thick = 2; // 箱の外壁の厚さ
wall_mid   = 5;
wall_heavy = 8;

module my_bolt() {
    difference() {
        screw(str("M",screw_dia,"x",screw_th), length=screw_length-2, anchor=BOTTOM, head="hex");
        translate([-screw_dia/2,0,0]) cube([screw_dia,0.2,screw_length]);
    }
}

module my_clamp() {
    // 背面
    translate([0,19.5,0])
        cuboid([clamp_w,wall_mid,45],anchor=BOTTOM, rounding=1);

    // top
    translate([0,12,40])
        cuboid([clamp_w,20,wall_mid], anchor=BOTTOM, rounding=1);

    // bottom
    difference(){
        translate([0,2,4])
            cuboid([clamp_w,40,wall_heavy],rounding=1);
        screw_hole(str("M",screw_dia,",15"), thread=screw_th, anchor=BOTTOM);
    }

    // joint
    translate([0,22,-joint_slide/2+40])
        rotate([-90,0,0])
            dovetail("male", width=joint_width, height=joint_depth,slide=joint_slide,angle=joint_angle);
}

module join_female() {
    w=joint_width+wall_mid*2;
    d=joint_depth+wall_thick;
    diff() cuboid([w,d,joint_slide], anchor=BOTTOM) {
        attach(TOP) cuboid([w,d,wall_mid], anchor=BOTTOM); // 屋根
        tag("remove") attach(FRONT) dovetail("female", width=joint_width, height=joint_depth,slide=joint_slide, angle=joint_angle);
    };
}

translate([20,-80, 0])
    my_bolt();
translate([70,-80, 0])
    my_bolt();

translate([20, -40, 0]) my_clamp();
translate([70, -40, 0]) my_clamp();

xs=(joint_width+wall_mid*2)/2 + xshift;
zs=height-joint_slide-wall_mid;
translate([xs,-(joint_depth+wall_thick)/2+wall_thick,zs])
 join_female();
 
translate([width-xs,-(joint_depth+wall_thick)/2+wall_thick,zs])
 join_female();


translate([0,0,height-40-wall_mid]) {
//    front_half(100)
//    translate([clamp_w/2,-22+wall_mid,0]) {
//        translate([5,0,0]) my_clamp();
//        translate([width-clamp_w-5,0,0]) my_clamp();
//    }
    translate([width/2,depth/2,40+wall_mid])
    difference() {
        cuboid([width,depth,height]
        , anchor=TOP
        , rounding=2
        , except=TOP
        );
        cuboid([width-wall_thick*2,depth-wall_thick*2,height-wall_thick], anchor=TOP);

    }
}
