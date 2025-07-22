module Denko
  class Board
    def tone(pin, frequency, duration=nil)
      period = (1_000_000.0 / frequency).round
      width = (period * 0.33).round
      @pwms[pin].period_us(period)
      @pwms[pin].pulse_width_us(width)
    end

    def no_tone(pin)
      pwm_enable(pin, false)
    end
  end
end
