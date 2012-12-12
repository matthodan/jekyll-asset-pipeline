module JekyllAssetPipeline
  class CssAssetTag < JekyllAssetPipeline::AssetTag
    def self.tag_name
      'css_asset_tag'
    end

    def self.output_type
      '.css'
    end
  end

  # Register CssAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JekyllAssetPipeline::CssAssetTag.tag_name, JekyllAssetPipeline::CssAssetTag)
end
