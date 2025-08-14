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

/* [Hidden] */
// Quality
$fs = 0.1;

include <BOSL2/std.scad>;

/* [Style] */
// (Style [flat])
style = "flat"; // ["flat","homing"]

/* [Size] */
// (default: 19 [16-19])
key_width = 19; // [16:.5:19]

// (default: 19 [16-19])
key_height = 19; // [16:.5:19]

//key_width = 16.5;
//key_height = 17.5;

// (default: 4)
key_depth = 4; // .5

// (Stem height [2.5])
stem_post_height = 2.5; // [2.5:.1:5]

/* [Hidden] */

stem_socket_depth = 2.4;
//stem_post_diameter = 5.8;
stem_post_diameter = 5.5;
stem_socket_long = 4.2;
stem_socket_short = 1.3;

wall_thickness = 1.2;
fillet_radius = 0.4;
key_top_taper = 0.5;

/*
 * keycap body
 */
module keycap_body() {
    // minkowski()で寸法が大きくなる分を補正
    m_offset = fillet_radius * 2;
    p_w = key_width - m_offset;
    p_d = key_height - m_offset;
    p_h = key_depth - m_offset;

    // 外殻の形状
    module outer_shell() {
        prismoid(
            size1 = [p_w, p_d],
            size2 = [p_w - key_top_taper*2, p_d - key_top_taper*2],
            h = p_h,
            rounding = 2.0
        );
    }
    // 内部をくり抜くためのパンチ形状
    module punch() {
        // minkowskiで内寸が狭くなるのを防ぐため、パンチの幅/奥行きは最終目標値から計算
        prismoid(
            size1 = [key_width - wall_thickness*2, key_height - wall_thickness*2],
            size2 = [(key_width - key_top_taper*2) - wall_thickness*2, (key_height - key_top_taper*2) - wall_thickness*2],
            // パンチの高さは、縮小された外殻の高さを基準にします
            h = p_h - wall_thickness,
            rounding = 2.0 - wall_thickness
        );
    }
    // 最後にminkowskiを適用
    minkowski() {
        difference() {
            outer_shell();
            punch();
        }
        sphere(r=fillet_radius);
    }
}

/*
 * Homing key
 */
module keycap_homing() {
    difference() {
        keycap_body();
        translate([0,0,key_depth-wall_thickness/2])
            cuboid([5, 2, wall_thickness/2], rounding=0.2);
    }
}

/*
 * stem
 */
module stem_structure() {
    final_ceiling_z = (key_depth - fillet_radius*2) - wall_thickness - fillet_radius;
    
    module stem_post() {
        translate([0, 0, final_ceiling_z - stem_post_height])
            cylinder(d = stem_post_diameter, h = stem_post_height, $fn=50);
    }
    
    module stem_punch() {
        post_bottom_z = final_ceiling_z - stem_post_height;
        translate([0, 0, post_bottom_z]) {
            union() {
                translate([-stem_post_diameter/2, -stem_socket_short/2, 0])
                    cube([stem_post_diameter, stem_socket_short, stem_socket_depth]);
                translate([-stem_socket_short/2, -stem_socket_long/2, 0])
                    cube([stem_socket_short, stem_socket_long, stem_socket_depth]);
            }
        }
    }
    
    difference() {
        stem_post();
        stem_punch();
    }
}

/*
 * Output
 */
union() {
    if ( style == "flat" )
        keycap_body();
    else
        keycap_homing();
    stem_structure();
}
