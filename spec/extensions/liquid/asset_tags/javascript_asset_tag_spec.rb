require './spec/helper'

describe JavaScriptAssetTag do
  specify { JavaScriptAssetTag.tag_name.must_equal('javascript_asset_tag') }
  specify { JavaScriptAssetTag.output_type.must_equal('.js') }
  specify { (JavaScriptAssetTag.superclass == JAP::AssetTag).must_equal(true) }
end

describe JAP do
  it "registers tag with Liquid" do
    ::Liquid::Template.tags[JAP::JavaScriptAssetTag.tag_name].must_equal(JAP::JavaScriptAssetTag)
  end
end
