require './spec/helper'

module JekyllAssetPipeline
  describe AssetTag do
    specify do
      AssetTag.extend?(LiquidBlockExtensions::ClassMethods).must_equal(true)
      AssetTag.include?(LiquidBlockExtensions).must_equal(true)
    end
  end
end
