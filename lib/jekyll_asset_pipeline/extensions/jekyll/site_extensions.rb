module JekyllAssetPipeline
  module JekyllSiteExtensions
    def self.included(base)
      base.class_eval do
        # Store the original Jekyll::Site#cleanup method
        old_cleanup_method = instance_method(:cleanup)

        # Override Jekyll::Site#cleanup
        define_method(:cleanup) do
          # Run the Jekyll::Site#cleanup method
          original_return_val = old_cleanup_method.bind(self).call()

          # Clear Jekyll Asset Pipeline cache
          Pipeline.clear_cache

          original_return_val
        end
      end
    end
  end
end
