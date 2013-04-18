module JekyllAssetPipeline
  # Default output for JavaScript assets
  class JsTagTemplate < JekyllAssetPipeline::Template
    def self.filetype
      '.js'
    end

    def self.priority
      -1
    end

    def html
      "<script src='/#{@path}/#{@filename}' type='text/javascript'></script>\n"
    end
  end
end
