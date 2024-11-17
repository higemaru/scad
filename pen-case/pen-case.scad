/*
 * 二つ折り定規をふたにするペンケース
 *   「ミドリ アルミ マルチ定規＜30cm＞ (42287006)」用
 *   https://www.midori-store.net/SHOP/42287006.html
 *   https://www.amazon.co.jp/gp/product/B0BT4KTPWX/
 * 
 * MIT License
 *
 * Copyright (c) 2023 KAWABATA, Kazumichi
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
 *
 */


// Quality
$fn = 128;

// Size (mm)
outer_w  = 40;
outer_d  = 170;
//outer_d  = 40;
outer_h  = 24;
//outer_h  = 10;
wall_t   = 2;
wall_t_top = 1;
corner_r = 2;

ruler_w_b = 30;
ruler_w_t = 14;
ruler_h_b = 1.75;
ruler_h_t = 3.75;
ruler_d   = 155;
//ruler_d   = 25;

difference() {
    // 外箱
    roundedCube([outer_w, outer_d, outer_h], corner_r);

    // 定規差し込み口
    translate([(outer_w - ruler_w_t)/2, 0, outer_h - wall_t_top ])
        cube([ruler_w_t, ruler_d, outer_h - wall_t - ruler_h_t]);

        translate([(outer_w - ruler_w_b) / 2, 0, outer_h - ruler_h_t - wall_t_top ]) {
        hull() {
            translate([(ruler_w_b - ruler_w_t) / 2, 0, 0])
                cube([ruler_w_t, ruler_d, ruler_h_t]);
            cube([ruler_w_b, ruler_d, ruler_h_b]);
        }
    }

    // 内部空間
    stopper_d = wall_t*2;
    // 中央付近までは広く
    translate([wall_t, wall_t, wall_t])
        cube([outer_w - wall_t * 2, ruler_d / 5*2 - wall_t * 2, outer_h - (ruler_h_t-ruler_h_b) - wall_t - wall_t]);

    // ふたがひっかかる中間地点
    translate([wall_t + (outer_w-ruler_w_b)/2, ruler_d / 5*2 - wall_t, wall_t])
        cube([ruler_w_b - wall_t * 2, stopper_d, outer_h - (ruler_h_t-ruler_h_b) - wall_t - wall_t]);

    // 奥も広く
    translate([wall_t, ruler_d / 5*2 - wall_t + stopper_d, wall_t])
        cube([outer_w - wall_t * 2, ruler_d / 5*3 + wall_t - stopper_d, outer_h - (ruler_h_t-ruler_h_b) - wall_t - wall_t]);
        
    // ふたが止まる場所
    translate([wall_t + (outer_w-ruler_w_b)/2, ruler_d, wall_t])
        cube([ruler_w_b - wall_t * 2, stopper_d, outer_h - (ruler_h_t-ruler_h_b) - wall_t - wall_t]);

    // 一番奥も広く
    translate([wall_t, ruler_d + stopper_d, wall_t])
        cube([outer_w - wall_t * 2, outer_d - ruler_d - stopper_d - wall_t, outer_h - (ruler_h_t-ruler_h_b) - wall_t - wall_t]);

}

// https://artificialarts.hatenablog.com/entry/2020/02/21/080303
module roundedCube(size=[15,15,15],radius=3, fragments=30)
{
    $fn=fragments;

    translate([radius,radius,0])
    cube([size[0]-radius*2,size[1]-radius*2,size[2]]);
    translate([radius,0,radius])
    cube([size[0]-radius*2,size[1],size[2]-radius*2]);
    translate([0,radius,radius])
    cube([size[0],size[1]-radius*2,size[2]-radius*2]);

    //Pillar
    translate([radius,radius,radius])
    cylinder(h=size[2]-radius*2, r=radius);
    translate([size[0]-radius,radius,radius])
    cylinder(h=size[2]-radius*2, r=radius);
    translate([radius,size[1]-radius,radius])
    cylinder(h=size[2]-radius*2, r=radius);
    translate([size[0]-radius,size[1]-radius,radius])
    cylinder(h=size[2]-radius*2, r=radius);
    
    //Side
    translate([0,0,size[2]-radius])
    {
        translate([radius,radius,0])
        rotate([0,90,0])
        cylinder(h = size[0]-radius*2, r=radius);
        translate([radius,size[1]-radius,0])
        rotate([0,90,0])
        cylinder(h = size[0]-radius*2, r=radius);
        translate([radius,radius,0])
        rotate([-90,0,0])
        cylinder(h = size[1]-radius*2, r=radius);
        translate([size[0]-radius,radius,0])
        rotate([-90,0,0])
        cylinder(h = size[1]-radius*2, r=radius);
    }
    translate([0,0,radius])
    {
        translate([radius,radius,0])
        rotate([0,90,0])
        cylinder(h = size[0]-radius*2, r=radius);
        translate([radius,size[1]-radius,0])
        rotate([0,90,0])
        cylinder(h = size[0]-radius*2, r=radius);
        translate([radius,radius,0])
        rotate([-90,0,0])
        cylinder(h = size[1]-radius*2, r=radius);
        translate([size[0]-radius,radius,0])
        rotate([-90,0,0])
        cylinder(h = size[1]-radius*2, r=radius);
    }
        
    //Corner
    translate([radius,radius,size[2]-radius])
    sphere(r=radius);
    translate([size[0]-radius,radius,size[2]-radius])
    sphere(r=radius);
    translate([radius,size[1]-radius,size[2]-radius])
    sphere(r=radius);
    translate([size[0]-radius,size[1]-radius,size[2]-radius])
    sphere(r=radius);
    
    translate([radius,radius,radius])
    sphere(r=radius);
    translate([size[0]-radius,radius,radius])
    sphere(r=radius);
    translate([radius,size[1]-radius,radius])
    sphere(r=radius);
    translate([size[0]-radius,size[1]-radius,radius])
    sphere(r=radius);
}
