module JekyllAssetPipeline
  class AssetTag < ::Liquid::Block
    extend JekyllAssetPipeline::LiquidBlockExtensions::ClassMethods
    include JekyllAssetPipeline::LiquidBlockExtensions
  end
end
