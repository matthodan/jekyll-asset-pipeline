module JAPR
  # This is a Liquid tag block extension
  # See documentation here:
  # https://github.com/Shopify/liquid/wiki/liquid-for-programmers#create-your-own-tag-blocks
  class AssetTag < ::Liquid::Block
    extend JAPR::LiquidBlockExtensions::ClassMethods
    include JAPR::LiquidBlockExtensions
  end
end
