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

// (Head Thickness [3.5])
bd = 3.5;  // ヘッドの厚み
// (Head radius [6.85])
br = 6.85; // ヘッドの半径
//br = 7.85; // ヘッドの半径
// (Head edge width [1.5])
ew = 1.5;  // ヘッドのエッジ幅

// (Shaft Length [3.3])
sl = 3.3;  // シャフトの長さ
// (Shaft radius [2.65])
sr = 2.65; // シャフトの半径

// (Hall hort dia [2.9])
hs = 2.9; // 穴の短径
// (Hall lenong dia [3.7])
hl = 3.7; // 穴の長径
// (Hall depth [5])
hd = 5;   // 穴の深さ

// (Convex head radius [14])
//rs = 20; // convex 部分の球体の半径
rs = 14; // convex 部分の球体の半径
// (Concave head depression [0.5])
cd = 0.5; // ヘッドの窪みの深さ

// (default shape flat/concave/convex)
default_shape = "flat";

/*
 * Switch 用キャップかぶせるなら、bd=2.0, br=6.0, sl=3.8 で元と同じくらい
 */


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


module _head_flat(rad=br){
    cyl(h=bd, r=rad,rounding=bd/2, center=false);
}
module _head_concave(rad=br) {
    difference(){
        cyl(h=bd, r=rad,rounding=bd/2, center=false);
        translate([0,0,bd-cd])
            cyl(h=cd,r=rad-ew, rounding=-0.25,center=false);
    }
}
module _head_convex(rad=br) {
    _head_concave(rad=rad);
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
module _stick(shape=default_shape, height=sl, rad=br) {
    difference() {
        union(){
            // ヘッド
            translate([0,0,height]) {
                if (shape=="concave") {
                    _head_concave(rad=rad);
                }
                else if (shape=="convex") {
                    _head_convex(rad=rad);
                }
                else {
                    _head_flat(rad=rad);
                }
            }
            // 軸
//            difference(){
                cylinder(h=sl+0.2, r=sr);
//                translate([0,0,(sl+0.2)/2]) cube([sr*2,0.2,sl+0.2],center=true);
//            }
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
module low_flat_wide() {
    _stick(shape="flat", height=2.3, rad=7.85);
}


shift = br*2+2;

/*
 * Sample
 */
 
//std_convex();
//low_convex();
//low_flat();
//low_flat_wide();

/*
 * à la carte
 */
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