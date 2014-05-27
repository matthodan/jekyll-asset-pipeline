require './spec/helper'

describe CssAssetTag do
  specify { CssAssetTag.tag_name.must_equal('css_asset_tag') }
  specify { CssAssetTag.output_type.must_equal('.css') }
  specify { (CssAssetTag.superclass == JAPR::AssetTag).must_equal(true) }
end

describe JAPR do
  it 'registers tag with Liquid' do
    ::Liquid::Template.tags[JAPR::CssAssetTag.tag_name]
      .must_equal(JAPR::CssAssetTag)
  end
end
