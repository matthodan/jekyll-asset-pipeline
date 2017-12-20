module JekyllAssetPipeline
  class TestConverter < JekyllAssetPipeline::Converter
    def self.filetype
      '.foo'
    end

    def convert
      'converted'
    end
  end

  class TestCompressor < JekyllAssetPipeline::Compressor
    def self.filetype
      '.foo'
    end

    def compress
      'compressed'
    end
  end

  class TestTemplate < JekyllAssetPipeline::Template
    def self.filetype
      '.foo'
    end

    def self.priority
      1
    end

    def html
      'test_template_html'
    end
  end
end
