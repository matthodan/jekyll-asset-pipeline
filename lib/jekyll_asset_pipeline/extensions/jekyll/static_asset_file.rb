module JekyllAssetPipeline
  class StaticAssetFile < ::Jekyll::StaticFile
    include JekyllAssetPipeline::JekyllStaticFileExtensions
  end
end
