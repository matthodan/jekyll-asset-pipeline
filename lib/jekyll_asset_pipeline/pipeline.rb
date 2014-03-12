module JekyllAssetPipeline
  class Pipeline
    class << self
      # Generate hash based on manifest
      def hash(source, manifest, options = {})
        options = DEFAULTS.merge(options)
        begin
          Digest::MD5.hexdigest(YAML::load(manifest).map! do |path|
            "#{path}#{File.mtime(File.join(source, path)).to_i}"
          end.join.concat(options.to_s))
        rescue Exception => e
          puts "Failed to generate hash from provided manifest."
          raise e
        end
      end

      # Run pipeline
      def run(manifest, prefix, source, destination, tag, type, config)
        # Get hash for pipeline
        hash = hash(source, manifest, config)

        # Check if pipeline has been cached
        if cache.has_key?(hash)
          # Return cached pipeline and cached status
          return cache[hash], true
        else
          begin
            puts "Processing '#{tag}' manifest '#{prefix}'"

            # Create and process new pipeline
            pipeline = self.new(manifest, prefix, source, destination, type, config)
            pipeline.assets.each do |asset|
              puts "Saved '#{asset.filename}' to '#{destination}/#{asset.output_path}'"
            end

            # Add processed pipeline to cache
            cache[hash] = pipeline

            # Return newly processed pipeline and cached status
            return pipeline, false
          rescue Exception => e
            # Add exception to cache
            cache[hash] = e

            # Re-raise the exception
            raise e
          end
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
        begin
          config = DEFAULTS.merge(config)
          staging_path = File.join(source, config['staging_path'])
          FileUtils.rm_rf(staging_path)
        rescue Exception => e
          puts "Failed to remove staged assets."

          # Re-raise the exception
          raise e
        end
      end

      # Add prefix to output
      def puts(message)
        $stdout.puts("Asset Pipeline: #{message}")
      end
    end

    # Initialize new pipeline
    def initialize(manifest, prefix, source, destination, type, options = {})
      @manifest = manifest
      @prefix = prefix
      @source = source
      @destination = destination
      @type = type
      @options = JekyllAssetPipeline::DEFAULTS.merge(options)

      process
    end

    attr_reader :assets, :html

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

      if @options['fingerprint'] == false
        @assets = [JekyllAssetPipeline::Asset.new(content, "#{@prefix}#{@type}")]
      else
        hash = JekyllAssetPipeline::Pipeline.hash(@source, @manifest, @options)
        @assets = [JekyllAssetPipeline::Asset.new(content, "#{@prefix}-#{hash}#{@type}")]
      end
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
      staging_path = @options['staging_path']

      @assets.each do |asset|
        directory = File.join(@source, staging_path, output_path)
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
      # Use display_path if defined, otherwise use output_path in url
      display_path = @options['display_path'] || @options['output_path']

      @html = @assets.map do |asset|
        klass = JekyllAssetPipeline::Template.subclasses.select do |t|
          t.filetype == File.extname(asset.filename).downcase
        end.sort! { |x, y| x.priority <=> y.priority }.last

        html = klass.new(display_path, asset.filename).html unless klass.nil?

        html
      end.join
    end
  end
end
