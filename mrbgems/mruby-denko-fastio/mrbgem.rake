MRuby::Gem::Specification.new('mruby-denko-fastio') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'

  # Should already be in build for ESP32 using PicoRuby gems.
  spec.add_dependency 'picoruby-gpio'
  spec.add_dependency 'picoruby-i2c'
  spec.add_dependency 'picoruby-spi'
  spec.add_dependency 'mruby-denko-esp32'
end
