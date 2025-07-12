module Denko
  class Board
    # Address ranges 0..7 and 120..127 are reserved.
    # Try each address in 8..119 (0x08 to 0x77).
    I2C_ADDRESS_RANGE = (0x08..0x77).to_a

    # Arbitrary 1kB limit for now
    def i2c_limit
      1024
    end

    def i2cs
      # :ESP32_I2C1 is the other available unit.
      # 8 and 9 are default pins Arduino uses. Could be muxed to others.
      # timeout: can be given. Defaults to 100ms.
      @i2cs ||= [
        ::I2C.new(unit: :ESP32_I2C0, frequency: 100_000, sda_pin: 8, scl_pin: 9)
      ]
    end

    def i2c_search(index)
      unit = i2cs[index]
      raise ArgumentError, "I2C unit index: #{index} does not exist" unless unit

      # Prepend 0 (invalid address) to avoid bus treating this as peripheral data.
      found = [0]
      I2C_ADDRESS_RANGE.each do |address|
        begin
          bytes = unit.read(address, 1)
          found << address if bytes[0].ord > 0
        rescue IOError
        end
      end
      update_i2c(index, found)
    end

    def i2c_write(index, address, bytes, frequency=100_000, repeated_start=false)
      unit = i2cs[index]
      raise ArgumentError, "I2C unit index: #{index} does not exist" unless unit

      bytes = [bytes].flatten unless bytes.class == Array
      raise ArgumentError, "exceeded #{i2c_limit} bytes for #i2c_write" if bytes.length > i2c_limit

      result = unit.write(address, *bytes)
    end

    def i2c_read(index, address, register, read_length, frequency=100_000, repeated_start=false)
      unit = i2cs[index]
      raise ArgumentError, "I2C unit index: #{index} does not exist" unless unit

      # Write register bytes first, then read, in one call.
      register = [register].flatten.compact unless register.class == Array
      bytes = unit.read(address, read_length, *register)

      # bytes is returned as String. Convert to byte array.
      byte_array = bytes.unpack("C*")

      # Prepend the address (0th element) to the data, and update the bus.
      byte_array.unshift(address)
      update_i2c(index, byte_array)
    end

    def update_i2c(index, data)
      dev = hw_i2c_comps[index]
      dev.update(data) if dev
    end
  end
end
