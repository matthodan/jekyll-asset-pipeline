module JAPR
  # Base class for asset compressors
  # See https://github.com/janosrusiczki/japr#asset-compression
  class Compressor
    extend JekyllAssetPipeline::SubclassTracking

    def initialize(content)
      @content = content
      @compressed = compress
    end

    # Returns compressed content
    attr_reader :compressed

    # Filetype to process (e.g. '.js')
    def self.filetype
      ''
    end

    # Logic to compress assets
    #
    # Available instance variables:
    # @content    Content to be compressed
    #
    # Returns compressed string
    def compress
      @content
    end
  end
end
