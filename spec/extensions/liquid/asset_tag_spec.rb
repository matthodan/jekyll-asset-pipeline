require './spec/helper'

describe AssetTag do
  specify { AssetTag.extend?(LiquidBlockExtensions::ClassMethods).must_equal(true) }
  specify { AssetTag.include?(LiquidBlockExtensions).must_equal(true) }
end
