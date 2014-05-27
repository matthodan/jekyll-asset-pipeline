module JAPR
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
      site = context.registers[:site]
      config = site.config['asset_pipeline'] || {}

      # Run Jekyll Asset Pipeline
      pipeline, cached = Pipeline.run(@nodelist.first, @markup.strip,
                                      site.source, site.dest,
                                      self.class.tag_name,
                                      self.class.output_type, config)

      if pipeline.is_a?(Pipeline)
        # Prevent Jekyll from cleaning up saved assets if new pipeline
        pipeline.assets.each do |asset|
          config = JAPR::DEFAULTS.merge(config)
          staging_path = File.expand_path(File.join(site.source,
                                                    config['staging_path']))
          site.static_files << Jekyll::StaticFile.new(site, staging_path,
                                                      asset.output_path,
                                                      asset.filename)
        end unless cached

        # Return HTML tag pointing to asset
        return pipeline.html
      else
        # Return nothing
        return nil
      end
    end
  end
end
