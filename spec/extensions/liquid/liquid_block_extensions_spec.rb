require './spec/helper'

describe LiquidBlockExtensions do
  describe LiquidBlockExtensions::ClassMethods do
    before do
      class MockLiquidBlockClassMethods
        extend LiquidBlockExtensions::ClassMethods
      end
    end

    describe '#output_type' do
      subject { MockLiquidBlockClassMethods.output_type }
      it 'is an empty string' do
        subject.must_be_instance_of(String)
        subject.must_equal('')
      end
    end

    describe '#tag_name' do
      subject { MockLiquidBlockClassMethods.tag_name }
      it 'is an empty string' do
        subject.must_be_instance_of(String)
        subject.must_equal('')
      end
    end
  end

  describe '#render(context)' do
    before do
      class MockLiquidBlock
        include LiquidBlockExtensions

        def initialize
          @markup = 'foobar_prefix'
        end

        def nodelist
          ['foobar_manifest']
        end

        def self.tag_name
          'test_tag'
        end

        def self.output_type
          '.baz'
        end
      end
    end

    subject { MockLiquidBlock.new.render(context) }

    context 'previously processed pipeline found in cache' do
      let(:site) do
        site = MiniTest::Mock.new
        site.expect(:config, {})
        site.expect(:source, source_path)
        site.expect(:dest, temp_path)
        site
      end

      let(:context) do
        context = MiniTest::Mock.new
        context.expect(:registers, site: site)
        context
      end

      let(:pipeline) do
        pipeline = MiniTest::Mock.new
        pipeline.expect(:is_a?, true, [Pipeline])
        pipeline.expect(:html, 'foobar_html')
        pipeline
      end

      it 'returns html of previously processed pipeline' do
        Pipeline.stub(:run, [pipeline, true]) do
          subject.must_equal('foobar_html')
        end
      end
    end

    context 'pipeline has not been previously processed' do
      let(:site) do
        site = MiniTest::Mock.new
        site.expect(:config, {})
        2.times { site.expect(:source, source_path) }
        2.times { site.expect(:dest, temp_path) }
        site.expect(:static_files, [])
        site
      end

      let(:context) do
        context = MiniTest::Mock.new
        context.expect(:registers, site: site)
        context
      end

      let(:asset) do
        asset = MiniTest::Mock.new
        asset.expect(:filename, 'foobar.baz')
        asset.expect(:output_path, 'foo/bar')
        asset
      end

      let(:assets) do
        [asset]
      end

      let(:pipeline) do
        pipeline = MiniTest::Mock.new
        pipeline.expect(:is_a?, true, [Pipeline])
        pipeline.expect(:assets, assets)
        pipeline.expect(:html, 'foobaz_html')
        pipeline
      end

      it 'creates new pipeline and processes it' do
        $stdout.stub(:puts, nil) do
          Pipeline.stub(:run, [pipeline, false]) do
            Jekyll::StaticFile.stub(:new, 'foobar') do
              subject.must_equal('foobaz_html')
            end
          end
        end
      end
    end
  end
end
