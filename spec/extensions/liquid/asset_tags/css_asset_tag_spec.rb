require './spec/helper'

describe CssAssetTag do
  specify { CssAssetTag.tag_name.must_equal('css_asset_tag') }
  specify { CssAssetTag.output_type.must_equal('.css') }
  specify { (CssAssetTag.superclass == JAP::AssetTag).must_equal(true) }
end

describe JAP do
  it "registers tag with Liquid" do
    ::Liquid::Template.tags[JAP::CssAssetTag.tag_name].must_equal(JAP::CssAssetTag)
  end
end
