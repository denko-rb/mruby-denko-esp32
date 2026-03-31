#include <mruby.h>
#include <mruby/array.h>
#include <mruby/hash.h>
#include <mruby/variable.h>
#include <mruby/value.h>

// From picoruby/mrbgems
#include <hal.h>
#include <machine.h>
#include <gpio.h>
#include <adc.h>
#include <pwm.h>

static mrb_value
denko_board_digital_write(mrb_state* mrb, mrb_value self) {
  mrb_int pin, val;
  mrb_get_args(mrb, "ii", &pin, &val);

  // From picoruby-gpio esp32 port
  GPIO_write(pin, val);
  return mrb_nil_value();
}

static mrb_value
denko_board_digital_read_raw(mrb_state* mrb, mrb_value self) {
  mrb_int pin;
  mrb_get_args(mrb, "i", &pin);
  // From picoruby-gpio
  return mrb_fixnum_value(GPIO_read(pin));
}

static mrb_value
denko_board_analog_read_raw(mrb_state* mrb, mrb_value self) {
  mrb_int pin;
  mrb_get_args(mrb, "i", &pin);
  // From picoruby-adc
  return mrb_fixnum_value(ADC_read_raw(pin));
}

static mrb_value
denko_board_micro_delay(mrb_state *mrb, mrb_value self) {
  mrb_int microseconds;
  mrb_get_args(mrb, "i", &microseconds);
  mrb_hal_task_sleep_us(mrb, microseconds);
  return self;
}

static mrb_value
denko_board_pwm_enable(mrb_state *mrb, mrb_value self) {
  mrb_int pin;
  mrb_bool state;
  mrb_get_args(mrb, "ib", &pin, &state);
  PWM_set_enabled(pin, state);
  return self;
}

static mrb_value
mrb_kernel_sleep(mrb_state *mrb, mrb_value self) {
  mrb_value arg;
  mrb_get_args(mrb, "|o", &arg);

  if (mrb_nil_p(arg)) {
    // No argument, so longest possible sleep. Maybe light sleep instead?
    Machine_delay_ms(UINT32_MAX);
  } else {
    mrb_float seconds = mrb_float(mrb_to_float(mrb, arg));

    if (seconds <= (mrb_float)UINT32_MAX / 1000.0) {
      Machine_delay_ms((uint32_t)(seconds * 1000));
    } else if (seconds > 0) {
      mrb_raise(mrb, E_ARGUMENT_ERROR, "sleep time cannot be longer than 4,294,967 seconds");
    } else {
      mrb_raise(mrb, E_ARGUMENT_ERROR, "sleep time cannot be negative");
    }
  }
  return self;
}

void
mrb_mruby_denko_esp32_gem_init(mrb_state* mrb) {
  // Denko module
  struct RClass *mrb_Denko = mrb_define_module(mrb, "Denko");

  // Denko::Board class
  struct RClass *mrb_Denko_Board = mrb_define_class_under(mrb, mrb_Denko, "Board", mrb->object_class);

  // System
  mrb_define_method(mrb, mrb_Denko_Board, "micro_delay",    denko_board_micro_delay,    MRB_ARGS_REQ(1));

  // DigitalIO
  mrb_define_method(mrb, mrb_Denko_Board, "digital_write",    denko_board_digital_write,    MRB_ARGS_REQ(2));
  mrb_define_method(mrb, mrb_Denko_Board, "digital_read_raw", denko_board_digital_read_raw, MRB_ARGS_REQ(1));

  // AnalogIO
  mrb_define_method(mrb, mrb_Denko_Board, "analog_read_raw",  denko_board_analog_read_raw,  MRB_ARGS_REQ(1));

  // PulseIO
  mrb_define_method(mrb, mrb_Denko_Board, "pwm_enable",       denko_board_pwm_enable,       MRB_ARGS_REQ(2));

  // Redefine Kernel#sleep to only use vTaskDelay()
  mrb_define_method(mrb, mrb->kernel_module, "sleep",         mrb_kernel_sleep,             MRB_ARGS_OPT(1));
}

void
mrb_mruby_denko_esp32_gem_final(mrb_state* mrb) {
}
