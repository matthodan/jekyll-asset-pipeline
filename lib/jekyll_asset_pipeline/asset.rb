module JekyllAssetPipeline
  class Asset
    def initialize(content, filename, source_path = nil)
      @source_path = source_path
      @content = content
      @filename = filename
    end

    attr_accessor :content, :filename, :output_path, :source_path
  end
end
