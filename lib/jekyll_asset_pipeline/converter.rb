module JekyllAssetPipeline
  class Converter < JekyllAssetPipeline::Extendable
    def initialize(file)
      @file = file
      @content = file.read
      @type = File.extname(@file).downcase
      begin
        @converted = self.convert
      rescue Exception => e
        puts "Failed to convert asset '#{@file.path}'."
        raise e
      end
    end

    def converted
      @converted
    end

    # Filetype to process (e.g. '.coffee')
    def self.filetype
      ''
    end

    # Logic to convert assets
    #
    # Available instance variables:
    # @file       File to be converted
    # @content    Contents of @file as a string
    # @type       Filetype of file (e.g. '.coffee')
    #
    # Returns converted string
    def convert
      @content
    end
  end
end
