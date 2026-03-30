// GPIO
void denko_fast_digital_write(uint8_t pin, uint8_t val);

// I2C
void* denko_rbi2c_to_ci2c(mrb_state* mrb, mrb_value bus);
void  denko_fast_i2c_write(void* i2c_obj, uint8_t address, uint8_t* byte_array, uint32_t size);

// SPI
void* denko_rbspi_to_cspi(mrb_state* mrb, mrb_value bus);
void  denko_fast_spi_write(void* spi_obj, uint8_t* byte_array, uint32_t size);
