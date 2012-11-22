module JekyllAssetPipeline
  # Default output for JavaScript assets
  class JavaScriptTagTemplate < JekyllAssetPipeline::Template
    def self.filetype
      '.js'
    end

    def html
      "<script src='/#{@path}/#{@filename}' type='text/javascript'></script>\n"
    end

    def priority
      -1
    end
  end
end
