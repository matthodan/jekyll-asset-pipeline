# frozen_string_literal: true

module JekyllAssetPipeline
  # Contains overrides for the needed Jekyll:Site methods
  # Included in Jekyll::Site
  module JekyllSiteExtensions
    def self.included(base)
      base.class_eval do
        # Store the original Jekyll::Site#cleanup method
        old_cleanup_method = instance_method(:cleanup)

        # Override Jekyll::Site#cleanup
        define_method(:cleanup) do
          # Run the Jekyll::Site#cleanup method
          original_return_val = old_cleanup_method.bind(self).call

          # Clear Jekyll Asset Pipeline cache
          Pipeline.clear_cache

          original_return_val
        end

        # Store the original Jekyll::Site#write method
        old_write_method = instance_method(:write)

        # Override Jekyll::Site#write
        define_method(:write) do
          # Run the Jekyll::Site#write method
          original_return_value = old_write_method.bind(self).call

          # Clear Jekyll Asset Pipeline staged assets
          config = self.config['asset_pipeline'] || {}
          Pipeline.remove_staged_assets(source, config)

          original_return_value
        end
      end
    end
  end
end
