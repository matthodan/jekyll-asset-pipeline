require './spec/helper'

describe LiquidBlockExtensions do
  describe LiquidBlockExtensions::ClassMethods do
    before do
      class MockLiquidBlock
        extend LiquidBlockExtensions::ClassMethods
      end
    end

    describe "#output_type" do
      subject { MockLiquidBlock.output_type }
      specify { subject.must_be_instance_of(String) }
    end

    describe "#tag_name" do
      subject { MockLiquidBlock.tag_name }
      specify { subject.must_be_instance_of(String) }
    end
  end

  describe "#render(context)" do
    before do
      class MockLiquidBlock
        include LiquidBlockExtensions

        def initialize
          @nodelist = ['foobar_manifest']
          @markup = 'foobar_prefix'
        end

        def self.tag_name
          'test_tag'
        end

        def self.output_type
          '.baz'
        end
      end

      unless defined?(JekyllAssetPipeline::Pipeline)
        module JekyllAssetPipeline
          class Pipeline
          end
        end
      end

      unless defined?(JekyllAssetPipeline::Cache)
        module JekyllAssetPipeline
          class Cache
            def self.has_key?
            end
            def self.get
            end
            def self.add(foo, bar)
            end
          end
        end
      end

      unless defined?(JekyllAssetPipeline::StaticAssetFile)
        module JekyllAssetPipeline
          class StaticAssetFile
          end
        end
      end
    end

    subject { MockLiquidBlock.new.render(context) }

    context "previously processed pipeline found in cache" do
      let(:site) do
        site = MiniTest::Mock.new
        site.expect(:config, {})
        site.expect(:source, source_path)
        site.expect(:dest, temp_path)
        site
      end

      let(:context) do
        context = MiniTest::Mock.new
        context.expect(:registers, { site: site })
        context
      end

      let(:pipeline) do
        pipeline = MiniTest::Mock.new
        pipeline.expect(:html, 'foobar_html')
        pipeline
      end

      it "returns html of previously processed pipeline" do
        JekyllAssetPipeline::Pipeline.stub(:hash, 'foobar_hash') do
          JekyllAssetPipeline::Cache.stub(:has_key?, true) do
            JekyllAssetPipeline::Cache.stub(:get, pipeline) do
              subject.must_equal('foobar_html')
            end
          end
        end
      end
    end

    context "pipeline has not been previously processed" do
      let(:site) do
        site = MiniTest::Mock.new
        site.expect(:config, {})
        2.times { site.expect(:source, source_path) }
        3.times { site.expect(:dest, temp_path) }
        1.times { site.expect(:static_files, []) }
        site
      end

      let(:context) do
        context = MiniTest::Mock.new
        context.expect(:registers, { site: site })
        context
      end

      let(:asset) do
        asset = MiniTest::Mock.new
        2.times { asset.expect(:filename, 'foobar.baz') }
        2.times { asset.expect(:output_path, 'foo/bar') }
        asset
      end

      let(:assets) do
        [asset]
      end

      let(:pipeline) do
        pipeline = MiniTest::Mock.new
        pipeline.expect(:process, nil)
        pipeline.expect(:assets, assets)
        pipeline.expect(:html, 'foobaz_html')
        pipeline
      end

      it "creates new pipeline and processes it" do
        JekyllAssetPipeline::Pipeline.stub(:hash, 'foobar_hash') do
          JekyllAssetPipeline::Cache.stub(:has_key?, false) do
            JekyllAssetPipeline::Pipeline.stub(:new, pipeline) do
              JekyllAssetPipeline::StaticAssetFile.stub(:new, 'foobar') do
                subject.must_equal('foobaz_html')
              end
            end
          end
        end
      end
    end
  end
end
