# frozen_string_literal: true

require './spec/helper'

module JekyllAssetPipeline
  describe JavaScriptAssetTag do
    specify do
      _(JavaScriptAssetTag.tag_name).must_equal('javascript_asset_tag')
      _(JavaScriptAssetTag.output_type).must_equal('.js')
      _(JavaScriptAssetTag.superclass == JekyllAssetPipeline::AssetTag)
        .must_equal(true)
    end

    it 'registers tag with Liquid' do
      _(
        ::Liquid::Template
          .tags[JekyllAssetPipeline::JavaScriptAssetTag.tag_name]
      ).must_equal(JekyllAssetPipeline::JavaScriptAssetTag)
    end
  end
end
