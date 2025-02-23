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

// (Quality)
$fn = 128;

// Size

// (Head Thickness)
bd = 3.5;  // ヘッドの厚み
// (Head radius)
br = 6.85; // ヘッドの半径
//br = 7.85; // ヘッドの半径
// (Head edge width)
ew = 1.5;  // ヘッドのエッジ幅

// (Shaft Length)
sl = 3.3;  // シャフトの長さ
// (Shaft radius)
sr = 2.65; // シャフトの半径

// (Hall hort dia)
hs = 2.9; // 穴の短径
// (Hall lenong dia)
hl = 3.7; // 穴の長径
// (Hall depth
hd = 5;   // 穴の深さ

// (Convex head radius)
rs = 20; // convex 部分の球体の半径
// (Concave head depression)
cd = 0.5; // ヘッドの窪みの深さ

module sliced_sphere() {
    // 球体をカットした時の断面の半径
    section = br - ew; 
    // 球の中心から断面までの距離
    len = sqrt(pow(rs, 2) - pow(section, 2));
    translate([0,0,-len])
    difference() {
        sphere(r = rs);
        translate([0,0,len-rs])
            cube(rs*2, center=true);
    }
}


module _head_flat(){
    cyl(h=bd, r=br,rounding=bd/2, center=false);
}
module _head_concave() {
    difference(){
        cyl(h=bd, r=br,rounding=bd/2, center=false);
        translate([0,0,bd-cd])
            cyl(h=cd,r=br-ew, rounding=-0.25,center=false);
    }
}
module _head_convex() {
    _head_concave();
    translate([0,0,bd-cd]) sliced_sphere();
}
module _shaft_hole() {
    difference(){
        cylinder(h=hd, r=hs*sqrt(2)/2);
        union(){
            translate([hs,0,hd/2]) cube([hs, hs, hd],center=true);
            translate([-hs,0,hd/2]) cube([hs, hs, hd],center=true);
        }
    }
}
module _stick(shape="concave", height=sl) {
    difference() {
        union(){
            // ヘッド
            translate([0,0,height]) {
                if (shape=="concave") {
                    _head_concave();
                }
                else if (shape=="convex") {
                    _head_convex();
                }
                else {
                    _head_flat();
                }
            }
            // 軸
            cylinder(h=sl+0.2, r=sr);
        }
    
        // 軸穴
        _shaft_hole();
    }
}

module std_concave() {
    _stick(shape="concave", height=sl);
}
module std_convex() {
    _stick(shape="convex", height=sl);
}
module std_flat() {
    _stick(shape="flat", height=sl);
}
module low_concave() {
    _stick(shape="concave", height=2.3);
}
module low_convex() {
    _stick(shape="convex", height=2.3);
}
module low_flat() {
    _stick(shape="flat", height=2.3);
}


shift = br*2+2;
//low_flat();
//translate([shift,0,0])
//    low_flat();


std_concave();
translate([shift,0,0])
    std_convex();
translate([shift*2,0,0])
    std_flat();
translate([0,-shift,0])
    low_concave();
translate([shift,-shift,0])
    low_convex();
translate([shift*2,-shift,0])
    low_flat();
