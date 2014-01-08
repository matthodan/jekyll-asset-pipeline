# Stdlib dependencies
require 'digest/md5'
require 'fileutils'
require 'time'
require 'yaml'
require 'zlib'

# Third-party dependencies
require 'jekyll'
require 'liquid'

# Jekyll extensions
require 'jap/extensions/jekyll/site_extensions'
require 'jap/extensions/jekyll/site'

# Liquid extensions
require 'jap/extensions/liquid/liquid_block_extensions'
require 'jap/extensions/liquid/asset_tag'
require 'jap/extensions/liquid/asset_tags/css_asset_tag'
require 'jap/extensions/liquid/asset_tags/javascript_asset_tag'

# Ruby extensions
require 'jap/extensions/ruby/subclass_tracking'

# Jekyll Asset Pipeline
require 'jap/version'
require 'jap/asset'
require 'jap/converter'
require 'jap/compressor'
require 'jap/template'
require 'jap/templates/javascript_tag_template'
require 'jap/templates/css_tag_template'
require 'jap/pipeline'

module JekyllAssetPipeline
  # Default configuration settings for Jekyll Asset Pipeline
  # Strings used for keys to play nice when merging with _config.yml
  #
  # 'output_path'       Destination for bundle file (within the '_site' directory)
  # 'display_path'      Optional.  Override path to assets for output HTML refs
  # 'staging_path'      Destination for staged assets (within project root directory)
  # 'bundle'            true = Bundle assets, false = Leave assets unbundled
  # 'compress'          true = Minify assets, false = Leave assets unminified
  # 'gzip'              true = Create gzip versions, false = Do not create gzip versions
  #
  DEFAULTS = {
    'output_path'   => 'assets',
    'display_path'  => nil,
    'staging_path'  => '.asset_pipeline',
    'bundle'        => true,
    'compress'      => true,
    'gzip'          => false
  }
end
