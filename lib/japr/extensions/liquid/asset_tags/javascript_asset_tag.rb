module JAPR
  class JavaScriptAssetTag < JAPR::AssetTag
    def self.tag_name
      'javascript_asset_tag'
    end

    def self.output_type
      '.js'
    end
  end

  # Register JavaScriptAssetTag tag with Liquid
  ::Liquid::Template.register_tag(JAPR::JavaScriptAssetTag.tag_name,
                                  JAPR::JavaScriptAssetTag)
end
