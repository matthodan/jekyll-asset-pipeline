module JekyllAssetPipeline
  class JsAssetTag < JekyllAssetPipeline::AssetTag
    def self.tag_name
      'js_asset_tag'
    end

    def self.tag_full_name
      'javascript_asset_tag'
    end

    def self.output_type
      '.js'
    end
  end

  # Register JsAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JekyllAssetPipeline::JsAssetTag.tag_name, JekyllAssetPipeline::JsAssetTag)
  ::Liquid::Template.register_tag(JekyllAssetPipeline::JsAssetTag.tag_full_name, JekyllAssetPipeline::JsAssetTag)
end
