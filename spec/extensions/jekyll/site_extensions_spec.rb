require './spec/helper'

describe JekyllSiteExtensions do
  before do
    # Add dummy data to cache for testing
    Pipeline.cache['foo'] = 'bar'
  end

  subject do
    # Create mock class
    class MockSite
      def cleanup
        'old_return_value'
      end

      def write
        'old_write_return_value'
      end

      include JekyllSiteExtensions
    end

    obj = MockSite.new
    obj.cleanup
  end

  it "clears JekyllAssetPipeline::Cache when Jekyll::Site#cleanup is called" do
    subject # Setup subject
    Pipeline.cache.has_key?('foo').must_equal(false)
  end

  it "returns the same value as the original Jekyll::Site#cleanup method" do
    subject.must_equal('old_return_value')
  end
end
