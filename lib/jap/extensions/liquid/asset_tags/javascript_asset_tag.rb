module JAP
  class JavaScriptAssetTag < JAP::AssetTag
    def self.tag_name
      'javascript_asset_tag'
    end

    def self.output_type
      '.js'
    end
  end

  # Register JavaScriptAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JAP::JavaScriptAssetTag.tag_name, JAP::JavaScriptAssetTag)
end
