module JekyllAssetPipeline
  # Default output for CSS assets
  class CssTagTemplate < JekyllAssetPipeline::Template
    def self.filetype
      '.css'
    end

    def html
      "<link href='/#{@path}/#{@filename}' rel='stylesheet' type='text/css' />\n"
    end

    def priority
      -1
    end
  end
end
