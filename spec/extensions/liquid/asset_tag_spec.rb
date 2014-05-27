require './spec/helper'

describe AssetTag do
  specify do
    AssetTag.extend?(LiquidBlockExtensions::ClassMethods).must_equal(true)
  end
  specify do
    AssetTag.include?(LiquidBlockExtensions).must_equal(true)
  end
end
