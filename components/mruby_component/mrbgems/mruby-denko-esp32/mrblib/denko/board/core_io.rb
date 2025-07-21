module Denko
  class Board
    INPUT_MODES  = [:input, :input_pullup, :input_pulldown, :input_adc]
    OUTPUT_MODES = [:output, :output_pwm]
    PIN_MODES = INPUT_MODES + OUTPUT_MODES

    def set_pin_mode(pin, mode=:input, options={})
      unless PIN_MODES.include?(mode)
        raise ArgumentError, "cannot set mode: #{mode}. Should be one of: #{PIN_MODES.inspect}"
      end

      case mode
      when :input
        gpios[pin] = GPIO.new(pin, GPIO::IN)
      when :input_pullup
        gpios[pin] = GPIO.new(pin, GPIO::IN)
        gpios[pin].set_pull(GPIO::PULL_UP)
      when :input_pulldown
        gpios[pin] = GPIO.new(pin, GPIO::IN)
        gpios[pin].set_pull(GPIO::PULL_DOWN)
      when :input_adc
        adcs[pin] ||= ADC.new(pin)
      when :output
        gpios[pin] = GPIO.new(pin, GPIO::OUT)
      when :output_pwm
        # Default to 1000 Hz when nothing given.
        frequency = 1_000
        # Denko uses ns for periods, but PWM#init only takes frequency. Convert and still give :period priority.
        if options[:period]
          frequency = 1_000_000_000.0 / options[:period]
        elsif options[:frequency]
          frequency = options[:frequency]
        end
        # Start with 0 duty cycle.
        pwms[pin] = PWM.new(pin, frequency: frequency, duty: 0)
      end
    end

    def set_pin_debounce(pin, debounce_time)
    end

    # digital_write implemented in C

    # dgital_read_raw implemented in C

    def digital_read(pin)
      self.update(pin, digital_read_raw(pin))
    end

    def pwm_write(pin, duty)
      @pwms[pin].pulse_width_us((duty / 1000.0).round)
    end

    def analog_read_raw(pin, negative_pin=nil, gain=nil, sample_rate=nil)
      @adcs[pin].read_raw
    end

    def analog_read(pin, negative_pin=nil, gain=nil, sample_rate=nil)
      self.update(pin, @adcs[pin].read_raw)
    end

    def set_listener(pin, state=:off, **options)
      puts "WARNING: listeners not implemented on ESP32. Inputs must be directly read"
    end

    # Convenience methods that wrap set_listener.
    def digital_listen(pin, divider=4)
      set_listener(pin, :on, mode: :digital, divider: divider)
    end

    def analog_listen(pin, divider=16)
      set_listener(pin, :on, mode: :analog, divider: divider)
    end

    def stop_listener(pin)
      set_listener(pin, :off)
    end

    def gpios
      @gpios ||= []
    end

    def pwms
      @pwms ||= []
    end

    def adcs
      @adcs ||= []
    end
  end
end
