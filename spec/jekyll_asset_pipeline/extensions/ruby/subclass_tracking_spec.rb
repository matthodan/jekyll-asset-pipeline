require './spec/helper'

module JekyllAssetPipeline
  describe SubclassTracking do
    describe '::subclasses' do
      before do
        class MockClass
          extend SubclassTracking
        end

        class MockSubclass < MockClass; end
      end

      it 'returns an array' do
        MockClass.subclasses.must_be_instance_of(Array)
      end

      it 'returned array contains all subclasses of MockSubclass' do
        MockClass.subclasses.must_include(MockSubclass)
      end
    end
  end
end
