module JAPR
  module TemplateHelper
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
  end
end
