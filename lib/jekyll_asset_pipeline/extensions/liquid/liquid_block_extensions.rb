module JekyllAssetPipeline
  module LiquidBlockExtensions
    module ClassMethods
      def output_type
        ''
      end

      def tag_name
        ''
      end
    end

    def render(context)
      # Get YAML manifest from Liquid block
      manifest = @nodelist.first
      prefix = @markup.lstrip.rstrip

      # Get site instance from Jekyll
      site = context.registers[:site]

      # Initialize configuration hash
      config = site.config['asset_pipeline'] || {}

      # Generate hash based on asset last modified dates and config options
      hash = JekyllAssetPipeline::Pipeline.hash(site.source, manifest, config)

      # Fetch pipeline from cache if recently processed
      if JekyllAssetPipeline::Cache.has_key?(hash)
        pipeline = JekyllAssetPipeline::Cache.get(hash)

        # Return HTML tags pointing to assets
        return pipeline.html
      else
        # Create pipeline and process assets
        puts "Asset Pipeline: Processing '#{self.class.tag_name}' manifest '#{prefix}'"
        pipeline = JekyllAssetPipeline::Pipeline.new(manifest, prefix, site.source, site.dest, self.class.output_type, config)
        pipeline.process

        # Prevent Jekyll from cleaning up saved assets
        pipeline.assets.each do |asset|
          puts "Asset Pipeline: Saved '#{asset.filename}' to '#{site.dest}/#{asset.output_path}'"
          site.static_files << JekyllAssetPipeline::StaticAssetFile.new(site, site.dest, asset.output_path, asset.filename)
        end

        # Cache pipeline
        JekyllAssetPipeline::Cache.add(hash, pipeline)

        # Return HTML tags pointing to assets
        return pipeline.html
      end
    end
  end
end
