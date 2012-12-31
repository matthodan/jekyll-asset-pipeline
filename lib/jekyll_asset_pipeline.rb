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
require 'jekyll_asset_pipeline/extensions/jekyll/static_file_extensions'
require 'jekyll_asset_pipeline/extensions/jekyll/static_asset_file'
require 'jekyll_asset_pipeline/extensions/jekyll/site_extensions'
require 'jekyll_asset_pipeline/extensions/jekyll/site'

# Liquid extensions
require 'jekyll_asset_pipeline/extensions/liquid/liquid_block_extensions'
require 'jekyll_asset_pipeline/extensions/liquid/asset_tag'
require 'jekyll_asset_pipeline/extensions/liquid/asset_tags/css_asset_tag'
require 'jekyll_asset_pipeline/extensions/liquid/asset_tags/javascript_asset_tag'

# Ruby extensions
require 'jekyll_asset_pipeline/extensions/ruby/subclass_tracking'

# Jekyll Asset Pipeline
require 'jekyll_asset_pipeline/version'
require 'jekyll_asset_pipeline/asset'
require 'jekyll_asset_pipeline/converter'
require 'jekyll_asset_pipeline/compressor'
require 'jekyll_asset_pipeline/template'
require 'jekyll_asset_pipeline/templates/javascript_tag_template'
require 'jekyll_asset_pipeline/templates/css_tag_template'
require 'jekyll_asset_pipeline/pipeline'

module JekyllAssetPipeline
  # Default configuration settings for Jekyll Asset Pipeline
  # Strings used for keys to play nice when merging with _config.yml
  DEFAULTS = {
    'display_path'  => 'assets',    # What path to use for display
    'output_path'   => 'assets',    # Destination for bundle file (within the '_site' directory)
    'bundle'        => true,        # true = Bundle assets, false = Leave assets unbundled
    'compress'      => true,        # true = Minify assets, false = Leave assets unminified
    'gzip'          => false        # true = Create gzip versions, false = Do not create gzip versions
  }
end
