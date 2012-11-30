require 'rubygems'
gem 'minitest' # Ensures we are using the gem and not the stdlib
require 'minitest/autorun'
require 'minitest/pride'
require 'jekyll_asset_pipeline'

include JekyllAssetPipeline

class MiniTest::Spec
  def current_path
    File.expand_path(File.dirname(__FILE__))
  end
end

