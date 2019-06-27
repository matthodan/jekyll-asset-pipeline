# frozen_string_literal: true

module JekyllAssetPipeline
  # Base class for asset converters
  # See https://github.com/matthodan/jekyll-asset-pipeline#asset-preprocessing
  class Converter
    extend JekyllAssetPipeline::SubclassTracking

    def initialize(asset)
      @content = asset.content
      @type = File.extname(asset.filename).downcase
      @dirname = asset.dirname
      @converted = convert
    end

    attr_reader :converted

    # Filetype to process (e.g. '.coffee')
    def self.filetype
      ''
    end

    # Finds a converter class based on a filename
    def self.klass(filename)
      ::JekyllAssetPipeline::Converter.subclasses.select do |c|
        c.filetype == File.extname(filename).downcase
      end.last
    end

    # Logic to convert assets
    #
    # Available instance variables:
    # @file       File to be converted
    # @content    Contents of @file as a string
    # @type       Filetype of file (e.g. '.coffee')
    #
    # Returns converted string
    def convert
      @content
    end
  end
end
