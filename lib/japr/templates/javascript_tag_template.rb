module JAPR
  # Default output for JavaScript assets
  class JavaScriptTagTemplate < JAPR::Template
    def self.filetype
      '.js'
    end

    def self.priority
      -1
    end

    def output_path
      root_path? ? '' : "/#{@path}"
    end

    def root_path?
      stripped_path = @path.to_s.strip
      stripped_path.nil? ||
        stripped_path.empty? ||
        stripped_path == 'nil' ||
        stripped_path == '/'
    end

    def html
      "<script src='#{output_path}/#{@filename}' " \
        "type='text/javascript'></script>"
    end
  end
end
