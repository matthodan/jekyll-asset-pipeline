require './spec/helper'

describe StaticAssetFile do
  specify { StaticAssetFile.include?(JekyllStaticFileExtensions).must_equal(true) }
end
