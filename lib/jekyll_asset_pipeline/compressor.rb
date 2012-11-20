module JekyllAssetPipeline
  class Compressor < JekyllAssetPipeline::Extendable
    def initialize(content)
      @content = content
      begin
        @compressed = self.compress
      rescue Exception => e
        puts "Failed to compress asset with '#{self.class.to_s}'."
        raise e
      end
    end

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
