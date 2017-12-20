require './spec/helper'

module JekyllAssetPipeline
  describe CssAssetTag do
    specify do
      CssAssetTag.tag_name.must_equal('css_asset_tag')
      CssAssetTag.output_type.must_equal('.css')
      (CssAssetTag.superclass == JekyllAssetPipeline::AssetTag)
        .must_equal(true)
    end

    it 'registers tag with Liquid' do
      ::Liquid::Template.tags[JekyllAssetPipeline::CssAssetTag.tag_name]
                        .must_equal(JekyllAssetPipeline::CssAssetTag)
    end
  end
end
