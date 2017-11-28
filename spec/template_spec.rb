require './spec/helper'

describe Template do
  context 'with default template' do
    describe 'class methods' do
      describe '::filetype' do
        specify { Template.filetype.must_be_instance_of(String) }
      end

      describe '::priority' do
        specify { Template.priority.must_be_kind_of(Integer) }
      end
    end

    describe 'instance methods' do
      subject { Template.new('path', 'somefile.foo') }

      describe '#new(path, filename)' do
        specify { subject.instance_variable_get(:@path).must_equal('path') }
        specify do
          subject.instance_variable_get(:@filename).must_equal('somefile.foo')
        end
      end

      describe 'html' do
        specify { subject.html.must_equal("path/somefile.foo\n") }
      end
    end
  end

  context 'with css_tag_template' do
    describe 'class methods' do
      describe '::filetype' do
        specify { CssTagTemplate.filetype.must_equal('.css') }
      end

      describe '::priority' do
        specify { CssTagTemplate.priority.must_equal(-1) }
      end
    end

    describe 'instance methods' do
      subject { CssTagTemplate.new('path', 'somefile.foo') }

      describe '#new(path, filename)' do
        specify do
          subject.instance_variable_get(:@path).must_equal('path')
        end
        specify do
          subject.instance_variable_get(:@filename).must_equal('somefile.foo')
        end
      end

      describe 'html' do
        specify do
          subject.html.must_equal("<link href='/path/somefile.foo' " \
                                  "rel='stylesheet' type='text/css' />")
        end
      end
    end
  end

  context 'with javascript_tag_template' do
    describe 'class methods' do
      describe '::filetype' do
        specify { JavaScriptTagTemplate.filetype.must_equal('.js') }
      end

      describe '::priority' do
        specify { JavaScriptTagTemplate.priority.must_equal(-1) }
      end
    end

    describe 'instance methods' do
      subject { JavaScriptTagTemplate.new('path', 'somefile.foo') }

      describe '#new(path, filename)' do
        specify do
          subject.instance_variable_get(:@path).must_equal('path')
        end
        specify do
          subject.instance_variable_get(:@filename).must_equal('somefile.foo')
        end
      end

      describe 'html' do
        specify do
          subject.html.must_equal("<script src='/path/somefile.foo' " \
                                  "type='text/javascript'></script>")
        end
      end
    end
  end

  context 'with custom template' do
    before { require './spec/resources/source/_plugins/japr' }
    describe 'class methods' do
      describe '::filetype' do
        specify { TestTemplate.filetype.must_equal('.foo') }
      end

      describe '::priority' do
        specify { TestTemplate.priority.must_equal(1) }
      end
    end

    describe 'instance methods' do
      before { require './spec/resources/source/_plugins/japr' }
      subject { TestTemplate.new('path', 'somefile.foo') }

      describe '#new(path, filename)' do
        specify do
          subject.instance_variable_get(:@path).must_equal('path')
        end
        specify do
          subject.instance_variable_get(:@filename).must_equal('somefile.foo')
        end
      end

      describe 'html' do
        specify { subject.html.must_equal('test_template_html') }
      end
    end
  end
end
