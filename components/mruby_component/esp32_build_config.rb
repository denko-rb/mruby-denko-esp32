MRuby::Build.new do |conf|
  toolchain :gcc

  [conf.cc, conf.objc, conf.asm].each do |cc|
    cc.command = 'gcc'
    cc.flags = [%w(-g -std=gnu99 -O3 -Wall -Werror-implicit-function-declaration -Wdeclaration-after-statement -Wwrite-strings)]
  end

  [conf.cxx].each do |cxx|
    cxx.command = 'g++'
    cxx.flags = [%w(-g -O3 -Wall -Werror-implicit-function-declaration)]
  end

  conf.linker do |linker|
    linker.command = 'gcc'
    linker.flags = [%w()]
    linker.libraries = %w(m)
    linker.library_paths = []
  end

  conf.archiver do |archiver|
    archiver.command = "ar"
  end

  conf.gembox 'default'
end

MRuby::CrossBuild.new('esp32') do |conf|
  toolchain :gcc

  conf.cc do |cc|
    cc.include_paths << ENV["COMPONENT_INCLUDES"].split(';')

    cc.flags << '-Wno-maybe-uninitialized'
    cc.flags << '-mlongcalls'
    cc.flags << '-std=gnu17'
    cc.flags = cc.flags.flatten.collect { |x| x.gsub('-MP', '') }

    cc.defines << %w(MRB_HEAP_PAGE_SIZE=64)
    cc.defines << %w(MRB_USE_IV_SEGLIST)
    cc.defines << %w(KHASH_DEFAULT_SIZE=8)
    cc.defines << %w(MRB_STR_BUF_MIN_SIZE=20)
    cc.defines << %w(MRB_GC_STRESS)
    cc.defines << %w(MRB_USE_METHOD_T_STRUCT)
    cc.defines << %w(MRB_NO_BOXING)

    cc.defines << %w(ESP_PLATFORM)

    # PicoRuby specific stuff
    cc.defines << %w(PICORB_VM_MRUBY)
    cc.defines << %w(PICORUBY_PORT_ESP32)
    cc.defines << %w(MRBC_USE_FLOAT)
    cc.include_paths << "#{__dir__}/mrbgems/picoruby-stubs/include"
  end

  conf.cxx do |cxx|
    cxx.include_paths = conf.cc.include_paths.dup

    cxx.flags = cxx.flags.flatten.collect { |x| x.gsub('-MP', '') }

    cxx.defines = conf.cc.defines.dup
  end

  conf.bins = []
  conf.build_mrbtest_lib_only
  conf.disable_cxx_exception

  # Add core mrbgems
  #
  # ## = This mrbgem likely doesn't work
  #  # = Likely works, but also unncessary
  #
  conf.gem core: 'mruby-array-ext'
  conf.gem core: 'mruby-bigint'
  ## conf.gem core: 'mruby-bin-config'
  ## conf.gem core: 'mruby-bin-debugger'
  ## conf.gem core: 'mruby-bin-mirb'
  ## conf.gem core: 'mruby-bin-mrbc'
  ## conf.gem core: 'mruby-bin-mruby'
  ## conf.gem core: 'mruby-bin-strip'
  # conf.gem core: 'mruby-binding'
  conf.gem core: 'mruby-catch'
  conf.gem core: 'mruby-class-ext'
  conf.gem core: 'mruby-cmath'
  conf.gem core: 'mruby-compar-ext'
  conf.gem core: 'mruby-compiler'
  conf.gem core: 'mruby-complex'
  conf.gem core: 'mruby-data'
  ## conf.gem core: 'mruby-dir'
  conf.gem core: 'mruby-enum-chain'
  conf.gem core: 'mruby-enum-ext'
  conf.gem core: 'mruby-enum-lazy'
  conf.gem core: 'mruby-enumerator'
  conf.gem core: 'mruby-errno'
  # conf.gem core: 'mruby-error'
  conf.gem core: 'mruby-eval'
  # conf.gem core: 'mruby-exit'
  # conf.gem core: 'mruby-fiber'
  conf.gem core: 'mruby-hash-ext'
  conf.gem core: 'mruby-io'
  conf.gem core: 'mruby-kernel-ext'
  conf.gem core: 'mruby-math'
  conf.gem core: 'mruby-metaprog'
  conf.gem core: 'mruby-method'
  conf.gem core: 'mruby-numeric-ext'
  conf.gem core: 'mruby-object-ext'
  conf.gem core: 'mruby-objectspace'
  conf.gem core: 'mruby-os-memsize'
  conf.gem core: 'mruby-pack'
  conf.gem core: 'mruby-proc-binding'
  conf.gem core: 'mruby-proc-ext'
  conf.gem core: 'mruby-random'
  conf.gem core: 'mruby-range-ext'
  conf.gem core: 'mruby-rational'
  conf.gem core: 'mruby-set'
  # conf.gem core: 'mruby-sleep'
  conf.gem core: 'mruby-socket'
  conf.gem core: 'mruby-sprintf'
  conf.gem core: 'mruby-string-ext'
  conf.gem core: 'mruby-struct'
  conf.gem core: 'mruby-symbol-ext'
  ## conf.gem core: 'mruby-test-inline-struct'
  ## conf.gem core: 'mruby-test'
  conf.gem core: 'mruby-time'
  # conf.gem core: 'mruby-toplevel-ext'

  # Wi-Fi and MQTT from mruby-esp32. Can be disabled if not needed.
  conf.gem github: "denko-rb/mruby-denko-wifi-esp32"
  conf.gem github: "denko-rb/mruby-denko-mqtt-esp32"

  # Use PicoRuby's mrbgems for hardware abstraction.
  conf.gem "#{__dir__}/mrbgems/picoruby-stubs"
  picoruby_mrbgems = "#{__dir__}/picoruby/mrbgems"
  conf.gem "#{picoruby_mrbgems}/picoruby-gpio"
  conf.gem "#{picoruby_mrbgems}/picoruby-pwm"
  conf.gem "#{picoruby_mrbgems}/picoruby-adc"
  conf.gem "#{picoruby_mrbgems}/picoruby-i2c"
  conf.gem "#{picoruby_mrbgems}/picoruby-spi"

  # ESP32 implementation of Denko::Board
  conf.gem "#{__dir__}/mrbgems/mruby-denko-esp32"
  # C optimized methods for Denko::Canvas on mruby
  conf.gem github: "denko-rb/mruby-denko-fastcanvas"
end
