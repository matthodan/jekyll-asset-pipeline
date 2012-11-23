require File.expand_path('../lib/jekyll_asset_pipeline/version', __FILE__)

Gem::Specification.new do |s|
  s.rubygems_version        = '1.8.24'

  # Metadata
  s.name                    = 'jekyll-asset-pipeline'
  s.version                 = JekyllAssetPipeline::VERSION
  s.date                    = Time.now
  s.summary                 = 'A powerful asset pipeline for Jekyll that bundles, converts, and minifies CSS and JavaScript assets.'
  s.description             = 'Jekyll Asset Pipeline adds asset preprocessing (CoffeeScript, Sass, Less, ERB, etc.), asset compression/minification (Yahoo YUI Compressor, Google Closure Compiler, etc.) to Jekyll.  Jekyll Asset Pipeline can be extended to support any preprocessing or compression library.'
  s.authors                 = ['Matt Hodan']
  s.email                   = 'matthew.c.hodan@gmail.com'
  s.homepage                = 'http://www.matthodan.com/2012/11/22/jekyll-asset-pipeline.html'
  s.license                 = 'MIT'

  # Dependencies
  s.add_runtime_dependency 'jekyll', '>= 0.10.0'
  s.add_runtime_dependency 'liquid', '>= 1.9.0'

  # Files
  s.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md'].to_a
end
