module JAPR
  class CssAssetTag < JAPR::AssetTag
    def self.tag_name
      'css_asset_tag'
    end

    def self.output_type
      '.css'
    end
  end

  # Register CssAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JAPR::CssAssetTag.tag_name, JAPR::CssAssetTag)
end
