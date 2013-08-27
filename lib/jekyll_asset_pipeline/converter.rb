module JekyllAssetPipeline
  class Converter
    extend JekyllAssetPipeline::SubclassTracking

    def initialize(asset)
      @content = asset.content
      @source_path = asset.source_path
      @type = File.extname(asset.filename).downcase
      @converted = self.convert
    end

    def converted
      @converted
    end

    # Filetype to process (e.g. '.coffee')
    def self.filetype
      ''
    end

    # Logic to convert assets
    #
    # Available instance variables:
    # @file       File to be converted
    # @content    Contents of @file as a string
    # @type       Filetype of file (e.g. '.coffee')
    # @source_path Original asset source path
    #
    # Returns converted string
    def convert
      @content
    end
  end
end
