module JekyllAssetPipeline
  class Template
    extend JekyllAssetPipeline::SubclassTracking

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
    # @filename       Name of bundle file
    # @path           Path to bundle file
    #
    # Returns string
    def html
      "#{@path}/#{@filename}\n"
    end
  end
end
