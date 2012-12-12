require './spec/helper'

describe JavaScriptAssetTag do
  specify { JavaScriptAssetTag.tag_name.must_equal('javascript_asset_tag') }
  specify { JavaScriptAssetTag.output_type.must_equal('.js') }
  specify { (JavaScriptAssetTag.superclass == JekyllAssetPipeline::AssetTag).must_equal(true) }
end

describe JekyllAssetPipeline do
  it "registers tag with Liquid" do
    ::Liquid::Template.tags[JekyllAssetPipeline::JavaScriptAssetTag.tag_name].must_equal(JekyllAssetPipeline::JavaScriptAssetTag)
  end
end
