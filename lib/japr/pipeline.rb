module JAPR
  # The pipeline itself, the run method is where it all happens
  # rubocop:disable ClassLength
  class Pipeline
    # rubocop:enable ClassLength
    class << self
      # Generate hash based on manifest
      def hash(source, manifest, options = {})
        options = DEFAULTS.merge(options)
        begin
          Digest::MD5.hexdigest(YAML.safe_load(manifest).map! do |path|
            "#{path}#{File.mtime(File.join(source, path)).to_i}"
          end.join.concat(options.to_s))
        rescue StandardError => se
          puts "Failed to generate hash from provided manifest: #{se.message}"
          raise se
        end
      end

      # Run the pipeline
      # This is called from JAPR::LiquidBlockExtensions.render or,
      # to be more precise, from JAPR::CssAssetTag.render and
      # JAPR::JavaScriptAssetTag.render
      # rubocop:disable ParameterLists
      def run(manifest, prefix, source, destination, tag, type, config)
        # rubocop:enable ParameterLists
        # Get hash for pipeline
        hash = hash(source, manifest, config)

        # Check if pipeline has been cached
        return cache[hash], true if cache.key?(hash)

        begin
          puts "Processing '#{tag}' manifest '#{prefix}'"
          pipeline = new(manifest, prefix, source, destination, type, config)
          process_pipeline(hash, pipeline)
        rescue StandardError => se
          # Add exception to cache
          cache[hash] = se

          # Re-raise the exception
          raise se
        end
      end

      # Cache processed pipelines
      def cache
        @cache ||= {}
      end

      # Empty cache
      def clear_cache
        @cache = {}
      end

      # Remove staged assets
      def remove_staged_assets(source, config)
        config = DEFAULTS.merge(config)
        staging_path = File.join(source, config['staging_path'])
        FileUtils.rm_rf(staging_path)
      end

      # Add prefix to output
      def puts(message)
        $stdout.puts("Asset Pipeline: #{message}")
      end

      private

      def process_pipeline(hash, pipeline)
        pipeline.assets.each do |asset|
          puts "Saved '#{asset.filename}' to " \
            "'#{pipeline.destination}/#{asset.output_path}'"
        end

        # Add processed pipeline to cache
        cache[hash] = pipeline

        # Return newly processed pipeline and cached status
        [pipeline, false]
      end
    end

    # Initialize new pipeline
    # rubocop:disable ParameterLists
    def initialize(manifest, prefix, source, destination, type, options = {})
      # rubocop:enable ParameterLists
      @manifest = manifest
      @prefix = prefix
      @source = source
      @destination = destination
      @type = type
      @options = JAPR::DEFAULTS.merge(options)

      process
    end

    attr_reader :assets, :html, :destination

    private

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

    # Collect assets based on manifest
    def collect
      @assets = YAML.safe_load(@manifest).map! do |path|
        full_path = File.join(@source, path)
        File.open(File.join(@source, path)) do |file|
          JAPR::Asset.new(file.read, File.basename(path),
                          File.dirname(full_path))
        end
      end
    rescue StandardError => se
      puts 'Asset Pipeline: Failed to load assets from provided ' \
           "manifest: #{se.message}"
      raise se
    end

    # Convert assets based on the file extension if converter is defined
    def convert
      @assets.each do |asset|
        # Convert asset multiple times if more than one converter is found
        finished = false
        while finished == false
          # Find a converter to use
          klass = JAPR::Converter.klass(asset.filename)

          # Convert asset if converter is found
          if klass.nil?
            finished = true
          else
            convert_asset(klass, asset)
          end
        end
      end
    end

    # Convert an asset with a given converter class
    def convert_asset(klass, asset)
      # Convert asset content
      converter = klass.new(asset)

      # Replace asset content and filename
      asset.content = converter.converted
      asset.filename = File.basename(asset.filename, '.*')

      # Add back the output extension if no extension left
      if File.extname(asset.filename) == ''
        asset.filename = "#{asset.filename}#{@type}"
      end
    rescue StandardError => se
      puts "Asset Pipeline: Failed to convert '#{asset.filename}' " \
           "with '#{klass}': #{se.message}"
      raise se
    end

    # Bundle multiple assets into a single asset
    def bundle
      content = @assets.map(&:content).join("\n")

      hash = JAPR::Pipeline.hash(@source, @manifest, @options)
      @assets = [JAPR::Asset.new(content, "#{@prefix}-#{hash}#{@type}")]
    end

    # Compress assets if compressor is defined
    def compress
      @assets.each do |asset|
        # Find a compressor to use
        klass = JAPR::Compressor.subclasses.select do |c|
          c.filetype == @type
        end.last

        break unless klass

        begin
          asset.content = klass.new(asset.content).compressed
        rescue StandardError => se
          puts "Asset Pipeline: Failed to compress '#{asset.filename}' " \
               "with '#{klass}': #{se.message}"
          raise se
        end
      end
    end

    # Create Gzip versions of assets
    def gzip
      @assets.map! do |asset|
        gzip_content = Zlib::Deflate.deflate(asset.content)
        [
          asset,
          JAPR::Asset.new(gzip_content, "#{asset.filename}.gz", asset.dirname)
        ]
      end.flatten!
    end

    # Save assets to file
    def save
      output_path = @options['output_path']
      staging_path = @options['staging_path']

      @assets.each do |asset|
        directory = File.join(@source, staging_path, output_path)
        write_asset_file(directory, asset)

        # Store output path of saved file
        asset.output_path = output_path
      end
    end

    # Write asset file to disk
    def write_asset_file(directory, asset)
      FileUtils.mkpath(directory) unless File.directory?(directory)
      begin
        # Save file to disk
        File.open(File.join(directory, asset.filename), 'w') do |file|
          file.write(asset.content)
        end
      rescue StandardError => se
        puts "Asset Pipeline: Failed to save '#{asset.filename}' to " \
             "disk: #{se.message}"
        raise se
      end
    end

    # Generate html markup pointing to assets
    def markup
      # Use display_path if defined, otherwise use output_path in url
      display_path = @options['display_path'] || @options['output_path']

      @html = @assets.map do |asset|
        klass = JAPR::Template.klass(asset.filename)
        html = klass.new(display_path, asset.filename).html unless klass.nil?

        html
      end.join
    end
  end
end
