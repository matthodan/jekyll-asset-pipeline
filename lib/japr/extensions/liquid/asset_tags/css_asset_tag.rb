# This comment is needed, otherwise Rubocop complains because of the
# register_tag below and a verbose comment is better than a :nodoc: :)
module JAPR
  # css_asset_tag Liquid block
  # See JAPR::AssetTag and JAPR::LiquidBlockExtensions
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
