/* [文字设置] */
// 上方可自定义文字。
top_text = "梁周线";
// 下方文字第一行。
lower_text_line_1 = "此生";
// 下方文字第二行。
lower_text_line_2 = "必驾";
// Windows 常见中文字体；如文字无法显示，可改成系统中已有的字体。
font_name = "Microsoft YaHei:style=Bold";
top_text_size = 16; // [10:0.5:20]
lower_text_size = 20; // [16:0.5:24]

/* [Hidden] */
part = "all";
$fn = 100;

sign_width = 96;
rectangle_height = 100;
triangle_height_ratio = 0.44;
base_thickness = 2.0;
lower_panel_thickness = 0.7;
text_thickness = 0.8;
outer_corner_radius = 5;
border_width = 5.2;
lower_panel_width = 84;
lower_panel_top_y = 96;
lower_panel_tip_y = 7;
lower_panel_triangle_height = 35;
lower_panel_corner_radius = 2.5;
lower_text_line_gap = lower_text_size * 1.8;
text_stroke = 0.18;

triangle_height = sign_width * triangle_height_ratio;
shield_height = rectangle_height + triangle_height;

gold_color = [0.78, 0.54, 0.22];
dark_color = [0.07, 0.08, 0.08];
top_text_color = dark_color;
lower_text_color = gold_color;

module rounded_polygon(points, radius) {
  offset(r = radius) {
    offset(delta = -radius) {
      polygon(points);
    }
  }
}

module shield_2d(width, rect_height, tri_height, radius) {
  safe_radius = min(radius, width / 10, rect_height / 3, tri_height / 4);
  rounded_polygon(
    [
      [-width / 2, tri_height],
      [-width / 2, tri_height + rect_height],
      [width / 2, tri_height + rect_height],
      [width / 2, tri_height],
      [0, 0]
    ],
    safe_radius
  );
}

module lower_panel_2d() {
  panel_rect_height = max(1, lower_panel_top_y - lower_panel_tip_y - lower_panel_triangle_height);
  translate([0, lower_panel_tip_y]) {
    shield_2d(
      lower_panel_width,
      panel_rect_height,
      lower_panel_triangle_height,
      lower_panel_corner_radius
    );
  }
}

module raised_text(label, size, height) {
  linear_extrude(height = height) {
    offset(delta = text_stroke) {
      text(label, size = size, font = font_name, halign = "center", valign = "center");
    }
  }
}

module gold_base() {
  color(gold_color) {
    linear_extrude(height = base_thickness) {
      shield_2d(sign_width, rectangle_height, triangle_height, outer_corner_radius);
    }
  }
}

module lower_dark_panel() {
  color(dark_color) {
    translate([0, 0, base_thickness]) {
      linear_extrude(height = lower_panel_thickness) {
        lower_panel_2d();
      }
    }
  }
}

module top_text_model() {
  title_y = triangle_height + rectangle_height * 0.78;
  color(top_text_color) {
    translate([0, title_y, base_thickness]) {
      raised_text(top_text, top_text_size, text_thickness);
    }
  }
}

module lower_text_model() {
  block_center_y = lower_panel_tip_y + lower_panel_triangle_height + 18;
  text_z = base_thickness + lower_panel_thickness;

  color(lower_text_color) {
    translate([0, block_center_y + lower_text_line_gap / 2, text_z]) {
      raised_text(lower_text_line_1, lower_text_size, text_thickness);
    }

    translate([0, block_center_y - lower_text_line_gap / 2, text_z]) {
      raised_text(lower_text_line_2, lower_text_size, text_thickness);
    }
  }
}

module selected_part() {
  if (part == "all") {
    gold_base();
    lower_dark_panel();
    top_text_model();
    lower_text_model();
  }

  if (part == "gold_base") {
    gold_base();
  }

  if (part == "lower_dark_panel") {
    lower_dark_panel();
  }

  if (part == "top_text") {
    top_text_model();
  }

  if (part == "lower_text") {
    lower_text_model();
  }
}

selected_part();
