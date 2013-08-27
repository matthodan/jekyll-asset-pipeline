module JekyllAssetPipeline
  class Asset
    def initialize(content, filename, source_path)
      @source_path = source_path
      @content = content
      @filename = filename
    end

    def source_path=(path)
      @source_path = path
    end

    attr_accessor :content, :filename, :output_path, :source_path
  end
end
