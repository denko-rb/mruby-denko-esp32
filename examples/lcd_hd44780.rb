# Use submodules without Denko:: prefix.
include Denko

# These pins are for the LOLIN S3 board. Change as needed.
lcd = Display::HD44780.new  pins: { rs: 47, enable: 48, d4: 39, d5: 40, d6: 41, d7: 42 },
                            cols: 16, rows: 2

# Bitmap for a custom character. 5 bits wide x 8 high.
# Useful for generating these: https://omerk.github.io/lcdchargen/
heart = [ 0b00000,
          0b00000,
          0b01010,
          0b11111,
          0b11111,
          0b01110,
          0b00100,
          0b00000 ]

# Define the character in CGRAM address 2. 0-7 are usable.
lcd.create_char(2, heart)

# Need to call home/clear/text_cursor so we go back to writing DDRAM.
lcd.home

# End the first line with the heart by writing its CGRAM address.
lcd.text "Hello World!   "
lcd.write(2)

# Change backlight, if it was given in pins: hash, and connected to a PWM pin:
# lcd.backlight.duty = 50
#
# Or just toggle if connected to a digital pin:
# lcd.backlight.on
# lcd.backlight.off

# Display a clock on second line, updating approximately every second.
loop do
  lcd.text_cursor 0,1
  lcd.text(Time.now.strftime("%I:%M:%S"))
  sleep 1
end
