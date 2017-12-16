module JAPR
  # Helper module used by JekyllAssetPipeline::AssetTag as well as
  # classed derived from it (Liquid tag block extensions)
  # See documentation here:
  # https://github.com/Shopify/liquid/wiki/liquid-for-programmers#create-your-own-tag-blocks
  module LiquidBlockExtensions
    # Unsurprisingly, class methods
    module ClassMethods
      def output_type
        ''
      end

      def tag_name
        ''
      end
    end

    def render(context)
      site = context.registers[:site]
      config = site.config.fetch('asset_pipeline', {})

      # Run Jekyll Asset Pipeline
      pipeline, cached = run_pipeline(site, config)

      return nil unless pipeline.is_a?(Pipeline)

      # Prevent Jekyll from cleaning up saved assets if new pipeline
      preserve_assets(site, config, pipeline) unless cached

      # Return HTML tag pointing to asset
      pipeline.html
    end

    private

    def run_pipeline(site, config)
      Pipeline.run(nodelist.first, @markup.strip, site.source, site.dest,
                   self.class.tag_name, self.class.output_type, config)
    end

    def preserve_assets(site, config, pipeline)
      pipeline.assets.each do |asset|
        config = JekyllAssetPipeline::DEFAULTS.merge(config)
        staging_path = File.expand_path(File.join(site.source,
                                                  config['staging_path']))
        site.static_files << Jekyll::StaticFile.new(site, staging_path,
                                                    asset.output_path,
                                                    asset.filename)
      end
    end
  end
end
