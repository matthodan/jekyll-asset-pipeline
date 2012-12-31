module JekyllAssetPipeline
  class Template
    extend JekyllAssetPipeline::SubclassTracking

    def initialize(path, filename, url)
      @path = path
      @filename = filename
      @url = url
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
      "#{@url}/#{@filename}\n"
    end
  end
end
