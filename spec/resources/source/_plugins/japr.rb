module JAPR
  class TestConverter < JAPR::Converter
    def self.filetype
      '.foo'
    end

    def convert
      'converted'
    end
  end

  class TestCompressor < JAPR::Compressor
    def self.filetype
      '.foo'
    end

    def compress
      'compressed'
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
