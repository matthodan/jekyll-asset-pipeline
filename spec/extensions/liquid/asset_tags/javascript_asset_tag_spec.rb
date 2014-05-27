require './spec/helper'

describe JavaScriptAssetTag do
  specify { JavaScriptAssetTag.tag_name.must_equal('javascript_asset_tag') }
  specify { JavaScriptAssetTag.output_type.must_equal('.js') }
  specify { (JavaScriptAssetTag.superclass == JAPR::AssetTag).must_equal(true) }
end

describe JAPR do
  it "registers tag with Liquid" do
    ::Liquid::Template.tags[JAPR::JavaScriptAssetTag.tag_name]
      .must_equal(JAPR::JavaScriptAssetTag)
  end
end
