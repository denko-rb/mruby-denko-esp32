#include <mruby.h>
#include <mruby/array.h>
#include <mruby/value.h>
#include <mruby/data.h>
// From picoruby/mrbgems
#include <gpio.h>
#include <i2c.h>
#include <spi.h>
extern struct mrb_data_type mrb_spi_type;

//
// GPIO write
//
void
denko_fast_digital_write(uint8_t pin, uint8_t val) {
  GPIO_write(pin, val);
}

//
// I2C write
//
void*
denko_rbi2c_to_ci2c(mrb_state* mrb, mrb_value bus) {
  mrb_int index = mrb_fixnum(mrb_funcall(mrb, bus, "i2c_index", 0));
  return (void*)index;
}

void
denko_fast_i2c_write(void* i2c_obj, uint8_t address, uint8_t* byte_array, uint32_t size) {
  I2C_write_timeout_us(
    (uint32_t)i2c_obj,
    address,
    byte_array,
    (size_t)size,
    false,
    (uint32_t)(100 * 1000)
  );
}

//
// SPI write
//
void*
denko_rbspi_to_cspi(mrb_state* mrb, mrb_value bus) {
  // Map Denko::SPI::Bus instance to ::SPI (picoruby-spi) instance
  mrb_int index     = mrb_fixnum(mrb_funcall(mrb, bus, "spi_index", 0));
  mrb_value board   = mrb_funcall(mrb, bus, "board", 0);
  mrb_value spis    = mrb_funcall(mrb, board, "spis", 0);
  mrb_value spi_obj = mrb_ary_ref(mrb, spis, index);
  return (void*)mrb_data_get_ptr(mrb, spi_obj, &mrb_spi_type);
}

void
denko_fast_spi_write(void* spi_obj, uint8_t* byte_array, uint32_t size) {
  SPI_write_blocking(
    (spi_unit_info_t *)spi_obj,
    byte_array,
    (size_t)size
  );
}

void
mrb_mruby_denko_fastio_gem_init(mrb_state* mrb) {
}

void
mrb_mruby_denko_fastio_gem_final(mrb_state* mrb) {
}
