Gem::Specification.new do |s|
  s.rubygems_version        = '1.8.24'

  # Metadata
  s.name                    = 'jekyll-asset-pipeline'
  s.version                 = '0.0.2'
  s.date                    = '2012-11-20'
  s.summary                 = 'Asset packaging system for Jekyll-powered sites.'
  s.description             = 'Bundle, convert and minify JavaScript and CSS assets.'
  s.authors                 = ['Matt Hodan']
  s.email                   = 'matthew.c.hodan@gmail.com'
  s.homepage                = 'http://github.com/matthodan/jekyll-asset-pipeline'
  s.license                 = 'MIT'

  # Dependencies
  s.add_runtime_dependency 'jekyll', '>= 0.10.0'
  s.add_runtime_dependency 'liquid', '>= 1.9.0'

  # Files
  s.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md'].to_a
end
