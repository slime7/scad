/* [贴墙部分] */
// 贴墙部分的宽度，按你的双面胶宽度适当调整
width = 60; // [10:2:80]
// 贴墙部分的高度，按你的双面胶宽度适当调整
height = 60; // [10:2:80]
// 贴墙部分的厚度，至少要比你的螺帽高
thickness = 6.4; // [4:0.2:10]

/* [连接定位部分] */
// 连接定位部分宽度，至少要容纳洞洞板设置的垫片
connector_width = 36; // [12:0.2:80]
// 连接定位部分高度，至少要容纳洞洞板设置的垫片
connector_height = 36; // [12:0.2:80]
// 连接定位部分深度，至少要容纳洞洞板设置的垫片
connector_thickness = 8; // [2:0.2:20]

/* [垫片孔部分] */
// 与洞洞板设置的螺丝孔到边缘的距离对应
spacer_distance = 8; // [6.4:0.2:20]
// 与洞洞板设置的垫片直径对应，可以稍宽一点防止塞不进去
spacer_diameter = 12; // [6.4:0.1:20]
// 与洞洞板设置的垫片高度对应
spacer_height = 6.5; // [0.2:0.2:30]

/* [半高设置] */
// 是否只生成2个孔的模块，用于连接最边上的2块板
is_half = false;
// 是否生成一个包边
half_side = true;
// 包边高度
side_height = 5; // [2:0.2:10]
// 包边厚度
side_thickness = 20; // [10:1:40]

/* [精度] */
// 不要设置太离谱
$fn = 100; // [60:20:100]

// 创建主要模型
module main_model() {
  union() {
    // 底部方块
    translate([(0 - width) / 2, (0 - (is_half ? 0 : height)) / 2, 0]) {
      cube([width, is_half ? height / 2 : height, thickness]);
    }

    // 顶部方块
    translate([ (0 - connector_width) / 2, (0 - (is_half ? 0 : connector_height)) / 2, thickness ]) {
      cube([connector_width, is_half ? connector_height / 2 : connector_height, connector_thickness]);
    }
  }
}

// 创建需要做差集的模型
module subtraction_model() {
  for (i = [-1, 1], j = [-1, 1]) {
    // 创建底部4个正六边形
    translate([i * spacer_distance, j * spacer_distance, -0.1]) {
      cylinder(h = 3.1, r = 4, $fn = 6);
    }
    // 螺丝孔
    translate([i * spacer_distance, j * spacer_distance, 3]) {
      cylinder(h = thickness + connector_thickness - 3 - spacer_height, r = 2, center = false);
    }
    // 板子连接部分
    translate([i * spacer_distance, j * spacer_distance, thickness + connector_thickness - spacer_height]) {
      cylinder(h = spacer_height, r = spacer_diameter / 2, center = false);
    }
  }
}

// 创建最终模型
difference() {
  main_model();
  subtraction_model();
}

// 半高时的包边
if (is_half && half_side) {
  translate([ (0 - width) / 2, 0 - side_height, 0 ]) {
    cube([width, side_height, side_thickness]);
  }
}