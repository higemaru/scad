/*
 * screw-driver.scad
 * bit を 2、3 個収納できる、ペン型のドライバー軸
 * bit は、5mm径六角形、28mm長

 * MIT License
 *
 * Copyright (c) 2024 KAWABATA, Kazumichi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.

 */


include <BOSL2/std.scad>
include <BOSL2/screws.scad>

// Quality
$fn = 128;
$slop = 0.025;

bit_dia = 5;      // bit 直径
bit_len = 28;     // bit 全長
bit_dep = 8;      // bit 差し込む穴の深さ
//bit_expand = 0.025; // bit 穴が緩い時、少し小さくする
bit_expand = 0.0125; // bit 穴が緩い時、少し小さくする

wall=1.25;       // 壁の厚さ。ペン先が薄くなりすぎないように

screw_dia = 8;  // 蓋のネジ穴の直径
screw_len = 6; // 蓋のネジ穴の深さ

pen_dia = 12;   // ペン軸の直径
pen_len = 101;  // ペン軸の長さ

cap_len = 10;   // 蓋の長さ（ネジ部分除く）
cap_dia = pen_dia;  // 蓋の直径

hall_dia = bit_dia + 1;      // bit 収納穴の直径
hall_len = bit_len * 3 + 1;  // bit 収納穴の深さ

nibs_dia = bit_dia + wall * 2; // ペン先の直径
nibs_len = 20;                 // ペン先部分の長さ


translate([0, 0, 0])
    difference() {
        // 外形
        difference() {
            cylinder(d=pen_dia, h=pen_len, $fn=6);
            difference(){
                cylinder(d=pen_dia, h=nibs_len, $fn=6);
                cylinder(r1=nibs_dia/2, r2=pen_dia/2, h=nibs_len);
            }
        }
        // 空洞
        translate([0, 0, pen_len-screw_len-hall_len])
            cylinder(d=hall_dia, h=hall_len);
        // ねじ山
        translate([0, 0, pen_len-screw_len])
            screw_hole(str("M",screw_dia,",",screw_len), thread=2, anchor=BOTTOM);
        // bit 差し込み穴
        cylinder(r=bit_dia/2-bit_expand, h=bit_dep, $fn=6);

//        // 穴調整のため断面見たい時用。
//        translate([-pen_dia/2, -pen_dia/2, 0])
//            cube([pen_dia, pen_dia/2, pen_len]);
    }


// ふた
translate([-pen_dia * 2, 0, 0])
    union(){
        difference(){
            screw(str("M",screw_dia,"x2"), length=screw_len+cap_len, anchor=BOTTOM, head="none");
            translate([-screw_dia/2,0,0]) cube([screw_dia, 0.1, screw_len+cap_len]);
        }
        cylinder(d=cap_dia, h=cap_len, $fn=12);
    }
 