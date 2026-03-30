module Denko
  class Board
    include Behaviors::Subcomponents

    def platform
      :esp32
    end

    def initialize
    end

    def convert_pin(pin)
      pin.to_i
    end

    def low
      0
    end

    def high
      1
    end

    # ESP32 ADC default
    def analog_read_resolution
      12
    end

    def analog_read_high
      4095
    end
    alias :adc_high :analog_read_high

    # Only asked by PulseIO::PWMOutput. All output pins can be PWM.
    # By always returning true, PWM starts on that pin immediately.
    def pin_is_pwm?(pin)
      true
    end

    def analog_write_resolution
      nil
    end

    def update(pin, message)
      if single_pin_components[pin]
        single_pin_components[pin].update(message)
      end
    end
  end
end
