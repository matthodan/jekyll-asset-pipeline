require './spec/helper'

describe JekyllStaticFileExtensions do
  subject do
    object = Object.new
    object.extend(JekyllStaticFileExtensions)
    object.write('foobar')
  end

  specify { subject.must_equal(true) }
end
