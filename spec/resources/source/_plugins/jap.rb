module JAPR
  class TestConverter < JAPR::Converter
    def self.filetype
      '.foo'
    end

    def convert
      return 'converted'
    end
  end

  class TestCompressor < JAPR::Compressor
    def self.filetype
      '.foo'
    end

    def compress
      return 'compressed'
    end
  end

  class TestTemplate < JAPR::Template
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
