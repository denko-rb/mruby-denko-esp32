# This sets Denko::Board::VERSION for the ESP32, independent of Denko::VERSION.
# Use it for this mrbgem's overall version.
require_relative "mrblib/denko/board/version"

# denko.rb from the CRuby gem requires most of it tree. Each module's .rb file defines
# an Array constant, with all files for that module, autoloaded by CRuby. With those
# Arrays defined here, all the same files can be added to the mruby build too.
require_relative "lib/denko/lib/denko"

MRuby::Gem::Specification.new('mruby-denko-esp32') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'
  spec.version = Denko::Board::VERSION

  # BCD conversion dependency for RTCs
  spec.add_dependency 'ruby_bcd', github: "dafyddcrosby/ruby_bcd", branch: "main"

  # ESP32 system gem always included. Wi-Fi and MQTT are handled in build config.
  spec.add_dependency 'mruby-esp32-system', github: "mruby-esp32/mruby-esp32-system"

  # For PicoRuby gem headers.
  spec.add_dependency 'picoruby-gpio'
  
  # Important to redefine spec.rbfiles so load order is explicit.
  spec.rbfiles = []

  # Define #sleep and other platform specific top level methods.
  spec.rbfiles << "#{dir}/mrblib/kernel.rb"

  # lib dir for Denko CRuby gem
  denko_lib_dir = "#{dir}/lib/denko/lib/denko"

  # Helpers & Behaviors needed early (from CRuby gem).
  spec.rbfiles << "#{denko_lib_dir}/version.rb"
  HELPER_FILES.each    { |f| spec.rbfiles << "#{denko_lib_dir}/helpers/#{f[1]}.rb" }
  BEHAVIORS_FILES.each { |f| spec.rbfiles << "#{denko_lib_dir}/behaviors/#{f[1]}.rb" }

  # Denko::Board implementation (from this mrbgem)
  spec.rbfiles += Dir.glob("#{dir}/mrblib/denko/board/*")

  #
  # Common peripheral implementation (from CRuby gem)
  #
  # Define parts of DigitalIO early. Some interfaces are bit-bang and depend on them.
  DIGITAL_IO_EARLY_FILES.each { |f| spec.rbfiles << "#{denko_lib_dir}/digital_io/#{f[1]}.rb" }

  # @rake_populate: OPTIONAL_MODULES_START

  # I2C FILES
  # spec.rbfiles << "#{denko_lib_dir}/i2c/bus_common.rb"
  # spec.rbfiles << "#{denko_lib_dir}/i2c/bus.rb"
  # spec.rbfiles << "#{denko_lib_dir}/i2c/peripheral.rb"

  # SPI FILES
  # spec.rbfiles << "#{denko_lib_dir}/spi/bus_common.rb"
  # spec.rbfiles << "#{denko_lib_dir}/spi/bus.rb"
  # spec.rbfiles << "#{denko_lib_dir}/spi/peripheral.rb"
  # spec.rbfiles << "#{denko_lib_dir}/spi/base_register.rb"
  # spec.rbfiles << "#{denko_lib_dir}/spi/input_register.rb"
  # spec.rbfiles << "#{denko_lib_dir}/spi/output_register.rb"

  # ANALOG_IO FILES
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/input_helper.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/input.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/potentiometer.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/joystick.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/ads111x.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/ads1100.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/ads1115.rb"
  # spec.rbfiles << "#{denko_lib_dir}/analog_io/ads1118.rb"

  # DIGITAL_IO FILES
  # spec.rbfiles << "#{denko_lib_dir}/digital_io/input.rb"
  # spec.rbfiles << "#{denko_lib_dir}/digital_io/output.rb"
  # spec.rbfiles << "#{denko_lib_dir}/digital_io/button.rb"
  # spec.rbfiles << "#{denko_lib_dir}/digital_io/relay.rb"
  # spec.rbfiles << "#{denko_lib_dir}/digital_io/pcf8574.rb"

  # PULSE_IO FILES
  # spec.rbfiles << "#{denko_lib_dir}/pulse_io/pwm_output.rb"
  # spec.rbfiles << "#{denko_lib_dir}/pulse_io/buzzer.rb"

  # LED FILES
  # spec.rbfiles << "#{denko_lib_dir}/led/base.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/rgb.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/seven_segment.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/seven_segment_array.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/seven_segment_spi.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/tm163x.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/tm1637.rb"
  # spec.rbfiles << "#{denko_lib_dir}/led/tm1638.rb"

  # DISPLAY/FONT FILES
  # spec.rbfiles << "#{denko_lib_dir}/display/font/bmp_5x7.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/font/bmp_6x8.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/font/bmp_8x16.rb"

  # DISPLAY FILES
  # spec.rbfiles << "#{denko_lib_dir}/display/hd44780.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/pixel_common.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/spi_common.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/spi_epaper_common.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/canvas.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/mono_oled.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/ssd1306.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/sh1106.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/sh1107.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/pcd8544.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/st7302.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/st7565.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/il0373.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/ssd168x.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/ssd1680.rb"
  # spec.rbfiles << "#{denko_lib_dir}/display/ssd1681.rb"

  # EEPROM FILES
  # spec.rbfiles << "#{denko_lib_dir}/eeprom/at24c.rb"

  # MOTOR FILES
  # spec.rbfiles << "#{denko_lib_dir}/motor/servo.rb"
  # spec.rbfiles << "#{denko_lib_dir}/motor/a3967.rb"
  # spec.rbfiles << "#{denko_lib_dir}/motor/l298.rb"

  # RTC FILES
  # spec.rbfiles << "#{denko_lib_dir}/rtc/ds3231.rb"

  # SENSOR FILES
  # spec.rbfiles << "#{denko_lib_dir}/sensor/helper.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/bmp180.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/bme280.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/hdc1080.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/htu21d.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/htu31d.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/aht.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/sht3x.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/sht4x.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/qmp6988.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/rcwl9620.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/generic_pir.rb"
  # spec.rbfiles << "#{denko_lib_dir}/sensor/vl53l0x.rb"

  # @rake_populate: OPTIONAL_MODULES_END

  # Deal with multiple classes adding the same file.
  spec.rbfiles.uniq!
end
