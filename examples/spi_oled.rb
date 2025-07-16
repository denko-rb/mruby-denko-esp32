# Add these files to the gem spec, in mrbgem.rake (uncomment there), before building this example:
#
#    spec.rbfiles << "#{denko_lib_dir}/spi/bus_common.rb"
#    spec.rbfiles << "#{denko_lib_dir}/spi/bus.rb"
#    spec.rbfiles << "#{denko_lib_dir}/spi/peripheral.rb"
#
#   spec.rbfiles << "#{denko_lib_dir}/display/pixel_common.rb"
#   spec.rbfiles << "#{denko_lib_dir}/display/canvas.rb"
#   spec.rbfiles << "#{denko_lib_dir}/display/mono_oled.rb"
#   spec.rbfiles << "#{denko_lib_dir}/display/spi_common.rb"
#   spec.rbfiles << "#{denko_lib_dir}/display/sh1106.rb"

board  = Denko::Board.new
spi    = Denko::SPI::Bus.new(board: board, index: 0)
oled   = Denko::Display::SH1106.new(bus: spi, pins: { select: 7, dc: 6, reset: 5 })

oled.rotate
canvas = oled.canvas

# Draw some text on the OLED's canvas (a Ruby memory buffer).
canvas = oled.canvas
baseline = 42
canvas.text_cursor = 27, baseline+15
canvas.text "Hello World!"

# Add some shapes to the canvas.
canvas.rectangle  x: 10, y: baseline,    w: 30, h: -30
canvas.circle     x: 66, y: baseline-15, r: 15
canvas.triangle   x1: 87,   y1: baseline,
                  x2: 117,  y2: baseline,
                  x3: 102,  y3: baseline-30

# 1px border to test screen edges.
canvas.rectangle x1: 0, y1: 0, x2: canvas.x_max, y2: canvas.y_max

# Send the canvas to the OLED's graphics RAM so it shows.
oled.draw
