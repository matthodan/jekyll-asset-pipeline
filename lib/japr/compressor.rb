module JAPR
  class Compressor
    extend JAPR::SubclassTracking

    def initialize(content)
      @content = content
      @compressed = self.compress
    end

    # Returns compressed content
    def compressed
      @compressed
    end

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
