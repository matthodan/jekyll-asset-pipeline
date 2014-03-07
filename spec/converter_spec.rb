require './spec/helper'

describe Converter do
  specify { Converter.extend?(SubclassTracking).must_equal(true) }

  context "with default converter class" do
    describe "class methods" do
      describe "::filetype" do
        specify { Converter.filetype.must_be_instance_of(String) }
      end
    end

    describe "instance methods" do
      let(:asset) { MiniTest::Mock.new }

      before do
        asset.expect(:content, 'foo')
        asset.expect(:filename, 'bar.baz')
        asset.expect(:dirname, '.')
      end

      subject { Converter.new(asset) }

      describe "#new(asset)" do
        specify { subject.instance_variable_get(:@content).must_equal('foo') }
        specify { subject.instance_variable_get(:@type).must_equal('.baz') }
        specify { subject.instance_variable_get(:@converted).must_equal('foo') }
      end

      describe "#converted" do
        specify { subject.converted.must_equal('foo') }
      end

      describe "#convert" do
        specify { subject.convert.must_equal('foo') }
      end
    end
  end

  context "with custom converter class" do
    before { require './spec/resources/source/_plugins/japr' }

    describe "class methods" do
      describe "::filetype" do
        specify { TestConverter.filetype.must_equal('.foo') }
      end
    end

    describe "instance methods" do
      let(:asset) { MiniTest::Mock.new }

      before do
        asset.expect(:content, 'unconverted')
        asset.expect(:filename, 'some_filename.foo')
        asset.expect(:dirname, '/some/path')
      end

      subject { TestConverter.new(asset) }

      describe "#new(asset)" do
        specify { subject.instance_variable_get(:@content).must_equal('unconverted') }
        specify { subject.instance_variable_get(:@type).must_equal('.foo') }
        specify { subject.instance_variable_get(:@converted).must_equal('converted') }
      end

      describe "#converted" do
        specify { subject.converted.must_equal('converted') }
      end

      describe "#convert" do
        specify { subject.convert.must_equal('converted') }
      end
    end
  end
end
