# frozen_string_literal: true

require './spec/helper'

module JekyllAssetPipeline
  describe Jekyll::Site do
    specify { Jekyll::Site.include?(JekyllSiteExtensions).must_equal(true) }
  end
end
