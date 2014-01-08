module JAP
  class CssAssetTag < JAP::AssetTag
    def self.tag_name
      'css_asset_tag'
    end

    def self.output_type
      '.css'
    end
  end

  # Register CssAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JAP::CssAssetTag.tag_name, JAP::CssAssetTag)
end
