# frozen_string_literal: true

require './spec/helper'

module JekyllAssetPipeline
  describe CssAssetTag do
    specify do
      _(CssAssetTag.tag_name).must_equal('css_asset_tag')
      _(CssAssetTag.output_type).must_equal('.css')
      _(CssAssetTag.superclass == JekyllAssetPipeline::AssetTag)
        .must_equal(true)
    end

    it 'registers tag with Liquid' do
      _(
        ::Liquid::Template.tags[JekyllAssetPipeline::CssAssetTag.tag_name]
      ).must_equal(JekyllAssetPipeline::CssAssetTag)
    end
  end
end
