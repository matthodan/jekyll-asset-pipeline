module JekyllAssetPipeline
  class Pipeline
    # Initialize new pipeline
    def initialize(manifest, prefix, source, destination, type, options = {})
      @manifest = manifest
      @prefix = prefix
      @source = source
      @destination = destination
      @type = type
      @options = JekyllAssetPipeline::DEFAULTS.merge(options)
    end

    attr_reader :assets, :html

    # Process the pipeline
    def process
      collect
      convert
      bundle if @options['bundle']
      compress if @options['compress']
      gzip if @options['gzip']
      save
      markup
    end

    # Generate hash based on manifest contents
    def self.hash(source, manifest, options = {})
      options = JekyllAssetPipeline::DEFAULTS.merge(options)
      begin
        Digest::MD5.hexdigest(YAML::load(manifest).map! do |path|
          "#{path}#{File.mtime(File.join(source, path)).to_i}"
        end.join.concat(options.to_s))
      rescue Exception => e
        puts "Asset Pipeline: Failed to generate hash from provided manifest."
        raise e
      end
    end

    private

    # Collect assets based on manifest
    def collect
      begin
        @assets = YAML::load(@manifest).map! do |path|
          File.open(File.join(@source, path)) do |file|
            JekyllAssetPipeline::Asset.new(file.read, File.basename(path))
          end
        end
      rescue Exception => e
        puts "Asset Pipeline: Failed to load assets from provided manifest."
        raise e
      end
    end

    # Convert assets based on the file extension if converter is defined
    def convert
      @assets.each do |asset|
        # Convert asset multiple times if more than one converter is found
        finished = false
        while finished == false
          # Find a converter to use
          klass = JekyllAssetPipeline::Converter.subclasses.select do |c|
            c.filetype == File.extname(asset.filename).downcase
          end.last

          # Convert asset if converter is found
          unless klass.nil?
            begin
              # Convert asset content
              converter = klass.new(asset)

              # Replace asset content and filename
              asset.content = converter.converted
              asset.filename = File.basename(asset.filename, '.*')

              # Add back the output extension if no extension left
              asset.filename = "#{asset.filename}#{@type}" if File.extname(asset.filename) == ''
            rescue Exception => e
              puts "Asset Pipeline: Failed to convert '#{asset.filename}' with '#{klass.to_s}'."
              raise e
            end
          else
            finished = true
          end
        end
      end
    end

    # Bundle multiple assets into a single asset
    def bundle
      content = @assets.map do |a|
        a.content
      end.join("\n")

      hash = JekyllAssetPipeline::Pipeline.hash(@source, @manifest, @options)
      @assets = [JekyllAssetPipeline::Asset.new(content, "#{@prefix}-#{hash}#{@type}")]
    end

    # Compress assets if compressor is defined
    def compress
      @assets.each do |asset|
        # Find a compressor to use
        klass = JekyllAssetPipeline::Compressor.subclasses.select do |c|
          c.filetype == @type
        end.last

        unless klass.nil?
          begin
            asset.content = klass.new(asset.content).compressed
          rescue Exception => e
            puts "Asset Pipeline: Failed to compress '#{asset.filename}' with '#{klass.to_s}'."
            raise e
          end
        end
      end
    end

    # Create Gzip versions of assets
    def gzip
      @assets.map! do |asset|
        gzip_content = Zlib::Deflate.deflate(asset.content)
        [asset, JekyllAssetPipeline::Asset.new(gzip_content, "#{asset.filename}.gz")]
      end.flatten!
    end

    # Save assets to file
    def save
      output_path = @options['output_path']

      @assets.each do |asset|
        # Create directories if necessary
        directory = File.join(@destination, output_path)
        FileUtils::mkpath(directory) unless File.directory?(directory)

        begin
          # Save file to disk
          File.open(File.join(directory, asset.filename), 'w') do |file|
            file.write(asset.content)
          end
        rescue Exception => e
          puts "Asset Pipeline: Failed to save '#{asset.filename}' to disk."
          raise e
        end

        # Store output path of saved file
        asset.output_path = output_path
      end
    end

    # Generate html markup pointing to assets
    def markup
      path = @options['output_path']
      url = @options['display_path']

      @html = @assets.map do |asset|
        klass = JekyllAssetPipeline::Template.subclasses.select do |t|
          t.filetype == File.extname(asset.filename).downcase
        end.sort! { |x, y| y.priority <=> x.priority }.last

        html = klass.new(path, asset.filename, url).html unless klass.nil?

        html
      end.join
    end
  end
end
