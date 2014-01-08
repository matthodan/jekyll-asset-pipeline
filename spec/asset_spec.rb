require './spec/helper'

describe Asset do
  subject { JAP::Asset.new('foo', 'bar') }

  describe "#new(content, filename)" do
    specify { subject.instance_variable_get(:@content).must_equal('foo') }
    specify { subject.instance_variable_get(:@filename).must_equal('bar') }
  end

  describe "#content" do
    before { subject.instance_variable_set(:@content, 'foobar') }
    specify { subject.content.must_equal('foobar') }
  end

  describe "#content=" do
    before { subject.content = 'foobar' }
    specify { subject.instance_variable_get(:@content).must_equal('foobar') }
  end

  describe "#filename" do
    before { subject.instance_variable_set(:@filename, 'foobar') }
    specify { subject.filename.must_equal('foobar') }
  end

  describe "#filename=" do
    before { subject.filename = 'foobar' }
    specify { subject.instance_variable_get(:@filename).must_equal('foobar') }
  end

  describe "#output_path" do
    before { subject.instance_variable_set(:@output_path, 'foobar') }
    specify { subject.output_path.must_equal('foobar') }
  end

  describe "#output_path=" do
    before { subject.output_path = 'foobar' }
    specify { subject.instance_variable_get(:@output_path).must_equal('foobar') }
  end
end
