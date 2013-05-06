require './spec/helper'

describe CssAssetTag do
  specify { CssAssetTag.tag_name.must_equal('css_asset_tag') }
  specify { CssAssetTag.tag_full_name.must_equal('stylesheet_asset_tag') }
  specify { CssAssetTag.output_type.must_equal('.css') }
  specify { (CssAssetTag.superclass == JekyllAssetPipeline::AssetTag).must_equal(true) }
end

describe JekyllAssetPipeline do
  it "registers tag with Liquid" do
    ::Liquid::Template.tags[JekyllAssetPipeline::CssAssetTag.tag_name].must_equal(JekyllAssetPipeline::CssAssetTag)
    ::Liquid::Template.tags[JekyllAssetPipeline::CssAssetTag.tag_full_name].must_equal(JekyllAssetPipeline::CssAssetTag)
  end
end
