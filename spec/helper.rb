require 'coveralls'
Coveralls.wear!

require 'rubygems'
gem 'minitest' # Ensures we are using the gem and not the stdlib
require 'minitest/autorun'
require 'minitest/pride'
require './spec/helpers/extensions/ruby/module'
require 'japr'

include JAPR

class MiniTest::Spec
  # Fetch current path
  def current_path
    File.expand_path(File.dirname(__FILE__))
  end

  def source_path
    File.join(File.expand_path(File.dirname(__FILE__)), 'resources', 'source')
  end

  def temp_path
    File.join(File.expand_path(File.dirname(__FILE__)), 'resources', 'temp')
  end

  def clear_temp_path
    FileUtils.remove_dir(temp_path, force: true)
  end

  # Let us use 'context' in specs
  class << self
    alias_method :context, :describe
  end
end
