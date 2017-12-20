require 'coveralls'
Coveralls.wear!

require 'rubygems'
gem 'minitest' # Ensures we are using the gem and not the stdlib
require 'minitest/autorun'
require 'minitest/pride'
require './spec/helpers/extensions/ruby/module'
require 'jekyll_asset_pipeline'

module MiniTest
  class Spec
    def source_path
      File.join(__dir__, 'resources', 'source')
    end

    def temp_path
      File.join(__dir__, 'resources', 'temp')
    end

    def clear_temp_path
      FileUtils.remove_dir(temp_path, force: true)
    end

    # Let us use 'context' in specs
    class << self
      alias context describe
    end
  end
end
