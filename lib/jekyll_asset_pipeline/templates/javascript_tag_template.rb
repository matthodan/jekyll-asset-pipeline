# frozen_string_literal: true

module JekyllAssetPipeline
  # Default output for JavaScript assets
  class JavaScriptTagTemplate < JekyllAssetPipeline::Template
    def self.filetype
      '.js'
    end

    def self.priority
      -1
    end

    def html
      "<script src='#{output_path}/#{@filename}' " \
        "type='text/javascript'></script>"
    end
  end
end
