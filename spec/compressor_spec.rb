require './spec/helper'

describe Compressor do
  specify { Compressor.extend?(SubclassTracking).must_equal(true) }

  context "with default compressor class" do
    describe "class methods" do
      describe "::filetype" do
        specify { Compressor.filetype.must_be_instance_of(String) }
      end
    end

    describe "instance methods" do
      subject { Compressor.new('uncompressed') }

      describe "#new(content)" do
        specify do
          subject.instance_variable_get(:@content).must_equal('uncompressed')
        end
        specify do
          subject.instance_variable_get(:@compressed).must_equal('uncompressed')
        end
      end

      describe "#compressed" do
        specify { subject.compressed.must_equal('uncompressed') }
      end

      describe "#compress" do
        specify { subject.compress.must_equal('uncompressed') }
      end
    end
  end

  context "with default compressor class" do
    before { require './spec/resources/source/_plugins/japr' }

    describe "class methods" do
      describe "::filetype" do
        specify { TestCompressor.filetype.must_equal('.foo') }
      end
    end

    describe "instance methods" do
      subject { TestCompressor.new('uncompressed') }

      describe "#new(content)" do
        specify do
          subject.instance_variable_get(:@content).must_equal('uncompressed')
        end
        specify do
          subject.instance_variable_get(:@compressed).must_equal('compressed')
        end
      end

      describe "#compressed" do
        specify { subject.compressed.must_equal('compressed') }
      end

      describe "#compress" do
        specify { subject.compress.must_equal('compressed') }
      end
    end
  end
end
