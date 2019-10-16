# frozen_string_literal: true

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
require 'jekyll_asset_pipeline/extensions/jekyll/site_extensions'
require 'jekyll_asset_pipeline/extensions/jekyll/site'

# Liquid extensions
require 'jekyll_asset_pipeline/extensions/liquid/liquid_block_extensions'
require 'jekyll_asset_pipeline/extensions/liquid/asset_tag'
require 'jekyll_asset_pipeline/extensions/liquid/asset_tags/css_asset_tag'
# rubocop:disable Metrics/LineLength
require 'jekyll_asset_pipeline/extensions/liquid/asset_tags/javascript_asset_tag'
# rubocop:enable Metrics/LineLength

# Ruby extensions
require 'jekyll_asset_pipeline/extensions/ruby/subclass_tracking'

# Jekyll Asset Pipeline
require 'jekyll_asset_pipeline/version'
require 'jekyll_asset_pipeline/asset'
require 'jekyll_asset_pipeline/converter'
require 'jekyll_asset_pipeline/compressor'
require 'jekyll_asset_pipeline/templates/template_helper'
require 'jekyll_asset_pipeline/template'
require 'jekyll_asset_pipeline/templates/javascript_tag_template'
require 'jekyll_asset_pipeline/templates/css_tag_template'
require 'jekyll_asset_pipeline/pipeline'

module JekyllAssetPipeline
  # Default configuration settings for Jekyll Asset Pipeline
  # Strings used for keys to play nice when merging with _config.yml
  #
  # 'output_path'  Destination for bundle file (within the '_site' directory)
  # 'display_path' Optional.  Override path to assets for output HTML refs
  # 'staging_path' Destination for staged assets (within project root directory)
  # 'bundle'       true = Bundle assets, false = Leave assets unbundled
  # 'compress'     true = Minify assets, false = Leave assets unminified
  # 'gzip'         true = Create gzip versions,
  #                false = Do not create gzip versions
  DEFAULTS = {
    'output_path' => 'assets',
    'display_path' => nil,
    'staging_path' => '.asset_pipeline',
    'bundle' => true,
    'compress' => true,
    'gzip' => false
  }.freeze
end
