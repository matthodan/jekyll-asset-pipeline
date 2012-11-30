module JekyllAssetPipeline
  class Template < JekyllAssetPipeline::Extendable
    def initialize(path, filename)
      @path = path
      @filename = filename
    end

    # Filetype to process (e.g. '.js')
    def self.filetype
      ''
    end

    # Priority of template (to override default templates)
    def self.priority
      0
    end

    # HTML output to return
    #
    # Available instance variables:
    # @path       Path to bundle file
    # @filename   Name of bundle file
    #
    # Returns string
    def html
      "#{@path}/#{@filename}\n"
    end
  end
end
