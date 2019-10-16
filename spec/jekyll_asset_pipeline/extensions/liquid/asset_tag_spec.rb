# frozen_string_literal: true

require './spec/helper'

module JekyllAssetPipeline
  describe AssetTag do
    specify do
      _(AssetTag.extend?(LiquidBlockExtensions::ClassMethods)).must_equal(true)
      _(AssetTag.include?(LiquidBlockExtensions)).must_equal(true)
    end
  end
end
