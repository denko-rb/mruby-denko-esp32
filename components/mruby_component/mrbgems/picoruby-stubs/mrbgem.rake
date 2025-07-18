MRuby::Gem::Specification.new('picoruby-stubs') do |spec|
  spec.license = 'MIT'
  spec.authors = 'vickash'
  spec.rbfiles += Dir.glob("#{dir}/mrblib/*")
end
