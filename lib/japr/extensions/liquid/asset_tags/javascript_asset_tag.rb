# This comment is needed, otherwise Rubocop complains because of the
# register_tag below and a verbose comment is better than a :nodoc: :)
module JAPR
  # javascript_asset_tag Liquid block
  # See JekyllAssetPipeline::AssetTag and JekyllAssetPipeline::LiquidBlockExtensions
  class JavaScriptAssetTag < JekyllAssetPipeline::AssetTag
    def self.tag_name
      'javascript_asset_tag'
    end

    def self.output_type
      '.js'
    end
  end

  # Register JavaScriptAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JekyllAssetPipeline::JavaScriptAssetTag.tag_name,
                                  JekyllAssetPipeline::JavaScriptAssetTag)
end
