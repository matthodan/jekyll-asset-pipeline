module JAP
  # Default output for CSS assets
  class CssTagTemplate < JAP::Template
    def self.filetype
      '.css'
    end

    def self.priority
      -1
    end

    def html
      "<link href='/#{@path}/#{@filename}' rel='stylesheet' type='text/css' />\n"
    end
  end
end
