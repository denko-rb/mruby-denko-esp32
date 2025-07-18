require_relative "lib/denko/lib/denko"
denko_lib_dir = "#{__dir__}/lib/denko/lib/denko"

start_comment = "  # @rake_populate: OPTIONAL_MODULES_START"
end_comment   = "  # @rake_populate: OPTIONAL_MODULES_END"
pattern       = /#{Regexp.escape(start_comment)}.*?#{Regexp.escape(end_comment)}/m

optionals = String.new
optionals << start_comment << "\n\n"

pairs = [
  {folder: "i2c",           arr: I2C_FILES},
  {folder: "spi",           arr: SPI_FILES},
  {folder: "one_wire",      arr: ONE_WIRE_FILES},
  {folder: "uart",          arr: UART_FILES},
  {folder: "analog_io",     arr: ANALOG_IO_FILES},
  {folder: "digital_io",    arr: DIGITAL_IO_FILES},
  {folder: "pulse_io",      arr: PULSE_IO_FILES},
  {folder: "led",           arr: LED_FILES},
  {folder: "display/font",  arr: FONT_FILES},
  {folder: "display",       arr: DISPLAY_FILES},
  {folder: "eeprom",        arr: EEPROM_FILES},
  {folder: "motor",         arr: MOTOR_FILES},
  {folder: "rtc",           arr: RTC_FILES},
  {folder: "sensor",        arr: SENSOR_FILES},
]

pairs.each do |pair|
  optionals << "  # #{pair[:folder].upcase} FILES\n"
  filenames = []
  pair[:arr].each { |f| filenames << f[1] unless filenames.include? f[1] }
  filenames.each do |name|
    optionals << "  # spec.rbfiles << \"\#{denko_lib_dir}/#{pair[:folder]}/#{name}.rb\"\n"
  end
  optionals << "\n"
end

optionals << end_comment

path        = "#{__dir__}/mrbgem.rake"
content     = File.read(path)
new_content = content.sub(pattern, optionals)
File.write(path, new_content)
