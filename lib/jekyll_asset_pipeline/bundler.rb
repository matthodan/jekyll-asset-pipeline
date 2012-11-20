module JekyllAssetPipeline
  class Bundler
    def initialize(site, prefix, manifest, type)
      @site = site
      @prefix = prefix
      @manifest = manifest
      @type = type

      # Initialize configuration hash
      overrides = @site.config['asset_pipeline']
      if overrides.is_a? Hash
        @config = JekyllAssetPipeline::DEFAULTS.merge(overrides)
      else
        @config = JekyllAssetPipeline::DEFAULTS
      end

      self.process
    end

    # Bundle assets into new file or fetch previously bundled file from cache
    def process
      @@cache ||= {}

      self.extract
      self.collect
      self.hashify

      if @@cache.has_key?(@hash)
        print "Asset Pipeline: Using cached bundle..."
        @file = @@cache[@hash]
        puts " used '#{@prefix}-#{@hash[0, 6]}' bundle."
      else
        print "Asset Pipeline: Compiling bundle..."

        # Create directories if necessary
        path = "#{@site.dest}/#{@config['output_path']}"
        FileUtils::mkpath(path) unless File.directory?(path)

        # Create bundle file
        self.convert
        self.bundle
        self.compress if @config['compress']

        @file = File.new(File.join(@site.dest, @config['output_path'], filename), "w")
        @file.write(@bundled)
        @file.close

        # Prevent Jekyll from cleaning up bundle file
        @site.static_files << JekyllAssetPipeline::AssetFile.new(@site, @site.dest, @config['output_path'], filename)

        # Save generated file to cache
        @@cache[@hash] = @file

        puts " finished compiling '#{@prefix}-#{@hash[0, 6]}' bundle."
      end
    end

    # Extract asset paths from YAML manifest
    def extract
      begin
        @assets = YAML::load(@manifest)
      rescue Exception => e
        puts "Asset Pipeline: Failed to read YAML manifest."
        raise e
      end
    end

    # Collect assets from various sources
    def collect
      @assets.map! do |path|
        begin
          file = File.open(File.join(@site.source, path))
        rescue Exception => e
          puts "Asset Pipeline: Failed to open asset file."
          raise e
        end
        file
      end
    end

    # Generate a hash id based on asset file paths and last modified dates
    def hashify
      payload = @assets.map do |file|
        "#{file.path}-#{@config['compress'].to_s}-#{file.mtime.to_i.to_s}"
      end
      @hash = Digest::MD5.hexdigest(payload.join)
    end

    # Search for a Converter to use to convert a file based on the file extension
    def convert
      @assets.map! do |file|
        converter_klass = JekyllAssetPipeline::Converter.subclasses.select do |c|
          c.filetype == File.extname(file).downcase
        end.last

        converted = nil
        unless converter_klass.nil?
          converter = converter_klass.new(file)
          converted = converter.converted
        else
          converted = file.read
        end
        converted
      end
    end

    # Bundle all of the separate asset files into one big file
    def bundle
      @bundled = @assets.join("\n")
    end

    # Search for a Compressor to use to compress a file based on the output type
    def compress
      compressor_klass = JekyllAssetPipeline::Compressor.subclasses.select do |c|
        c.filetype == @type
      end.last

      unless compressor_klass.nil?
        compressor = compressor_klass.new(@bundled)
        @bundled = compressor.compressed
      end
    end

    # Return filename of bundle
    def filename
      "#{@prefix}-#{@hash}#{@type}"
    end

    # Return an HTML tag that points to the bundle file
    def html_tag
      case @type
      when '.js'
        return "<script src='/#{@config['output_path']}/#{filename}' type='text/javascript'></script>\n"
      when '.css'
        return "<link href='/#{@config['output_path']}/#{filename}' rel='stylesheet' type='text/css' />\n"
      else
        return ''
      end
    end
  end
end
