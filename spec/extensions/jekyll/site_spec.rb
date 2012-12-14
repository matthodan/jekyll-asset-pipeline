require './spec/helper'

describe Jekyll::Site do
  specify { Jekyll::Site.include?(JekyllSiteExtensions).must_equal(true) }
end
