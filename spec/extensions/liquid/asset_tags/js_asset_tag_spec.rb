require './spec/helper'

describe JsAssetTag do
  specify { JsAssetTag.tag_name.must_equal('js_asset_tag') }
  specify { JsAssetTag.tag_full_name.must_equal('javascript_asset_tag') }
  specify { JsAssetTag.output_type.must_equal('.js') }
  specify { (JsAssetTag.superclass == JekyllAssetPipeline::AssetTag).must_equal(true) }
end

describe JekyllAssetPipeline do
  it "registers tag with Liquid" do
    ::Liquid::Template.tags[JekyllAssetPipeline::JsAssetTag.tag_name].must_equal(JekyllAssetPipeline::JsAssetTag)
    ::Liquid::Template.tags[JekyllAssetPipeline::JsAssetTag.tag_full_name].must_equal(JekyllAssetPipeline::JsAssetTag)
  end
end
