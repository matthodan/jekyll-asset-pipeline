require File.expand_path('../lib/jekyll_asset_pipeline/version', __FILE__)

Gem::Specification.new do |s|
  # Metadata
  s.name = 'jekyll-asset-pipeline'
  s.version = JekyllAssetPipeline::VERSION
  s.date = Time.now

  s.summary = <<-SUMMARY
    A powerful asset pipeline for Jekyll that bundles, converts, and minifies
    CSS and JavaScript assets.
  SUMMARY

  s.description = <<-DESCRIPTION
    Jekyll Asset Pipeline adds asset preprocessing (CoffeeScript, Sass,
    Less, ERB, etc.) and asset compression / minification / gzip (Yahoo YUI
    Compressor, Google Closure Compiler, etc.) to Jekyll.
  DESCRIPTION

  s.authors = ['Matt Hodan', 'Janos Rusiczki']
  s.email = ['matthew.c.hodan@gmail.com', 'janos.rusiczki@gmail.com']
  s.homepage = 'https://github.com/matthodan/jekyll-asset-pipeline'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.1.0'
  s.rubygems_version = '2.2.2'

  # Runtime dependencies
  s.add_runtime_dependency 'jekyll', '~> 3.5'
  s.add_runtime_dependency 'liquid', '~> 4.0'

  # Development dependencies
  s.add_development_dependency 'minitest', '~> 5.2'
  s.add_development_dependency 'rake', '~> 12.0'

  # Files
  s.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md'].to_a
end
