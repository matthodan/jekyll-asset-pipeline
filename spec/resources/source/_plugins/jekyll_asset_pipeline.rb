module JekyllAssetPipeline
  class TestConverter < JekyllAssetPipeline::Converter
    def self.filetype
      '.foo'
    end

    def convert
      return 'converted'
    end
  end

  class TestCompressor < JekyllAssetPipeline::Compressor
    def self.filetype
      '.foo'
    end

    def compress
      return 'compressed'
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
