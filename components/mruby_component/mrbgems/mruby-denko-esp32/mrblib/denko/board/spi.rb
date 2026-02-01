module Denko
  class Board
    # Arbitrary 1kB limit for now
    def spi_limit
      1024
    end

    def spis
      return @spis if @spis

      # :ESP32_HSPI_HOST should be available on all. Aka :SPI2_HOST.
      # These are default pins Arduino uses for ESP32 S3.
      # Some may have :ESP32_VSPI_HOST, aka :SPI3_HOST
      hspi = ::SPI.new  unit:      :ESP32_HSPI_HOST,
                        frequency: 10_000_000,
                        sck_pin:   12,
                        cipo_pin:  13,
                        copi_pin:  11,
                        mode:      0,
                        first_bit: ::SPI::MSB_FIRST
      @spis = [hspi]
    end

    def spi_transfer(spi_index, select, write: [], read: 0, frequency: 1_000_000, mode: 0, bit_order: :msbfirst)
      # Should de-init and re-init a ::SPI instance if frequency and/or bit_order changes?
      raise ArgumentError, "no bytes to read or write" if (read == 0) && (write.empty?)
      raise ArgumentError, "select pin cannot be nil when reading" if (read != 0) && (select == nil)

      # If reading more bytes than writing
      additional_read = read - write.length
      additional_read = 0 if additional_read < 0

      digital_write(select, 0) if select
      read_bytes = spis[0].transfer(write, additional_read_bytes: additional_read)
      digital_write(select, 1) if select

      if (read > 0 && select)
        # read_bytes is returned as String. Convert to byte array.
        byte_array = read_bytes.unpack("C*")

        # If reading fewer bytes than writing
        read_bytes = read_bytes[0..read-1]

        self.update(select, byte_array)
      end
    end

    def spi_listen(spi_index, select, read: 0, frequency: nil, mode: nil, bit_order: nil)
      raise NotImplementedError, "Board#spi_listen not implemented on ESP32"
    end

    def spi_listeners
      @spi_listeners ||= Array.new
    end
  end
end
