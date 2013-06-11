module JekyllAssetPipeline
  class Asset
    def initialize(content, filename, dirname = '.')
      @content = content
      @filename = filename
      @dirname = dirname
    end

    attr_accessor :content, :filename, :dirname, :output_path
  end
end
