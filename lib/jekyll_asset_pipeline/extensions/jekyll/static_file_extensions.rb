module JekyllAssetPipeline
  module JekyllStaticFileExtensions
    # Override #write method since the asset file is dynamically created
    def write(dest)
      true
    end
  end
end
