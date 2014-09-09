# JAPR (Jekyll Asset Pipeline Reborn)

[![Gem Version](https://badge.fury.io/rb/japr.png)](http://badge.fury.io/rb/japr)
[![Build Status](https://secure.travis-ci.org/kitsched/japr.png)](https://travis-ci.org/kitsched/japr)
[![Coverage Status](https://coveralls.io/repos/kitsched/japr/badge.png?branch=master)](https://coveralls.io/r/kitsched/japr?branch=master)
[![Dependency Status](https://gemnasium.com/kitsched/japr.png)](https://gemnasium.com/kitsched/japr)
[![Code Climate](https://codeclimate.com/github/kitsched/japr.png)](https://codeclimate.com/github/kitsched/japr)

JAPR is a powerful asset pipeline that automatically collects, converts and compresses / minifies your site's JavaScript and CSS assets when you compile your [Jekyll](http://jekyllrb.com/) site.

This project is a fork of [Jekyll Asset Pipeline](https://github.com/matthodan/jekyll-asset-pipeline) by [Matt Hodan](https://github.com/matthodan) which, unfortunately, was pretty much abandonware.

## Table of Contents

- [Features](#features)
- [How It Works](#how-it-works)
- [Getting Started](#getting-started)
- [Asset Preprocessing](#asset-preprocessing)
  - [CoffeeScript](#coffeescript)
  - [SASS / SCSS](#sass--scss)
  - [LESS](#less)
  - [Successive Preprocessing](#successive-preprocessing)
- [Asset Compression](#asset-compression)
  - [Yahoo's YUI Compressor](#yahoos-yui-compressor)
  - [Google's Closure Compiler](#googles-closure-compiler)
- [Templates](#templates)
- [Configuration](#configuration)
- [Octopress](#octopress)
- [Contribute](#contribute)
- [Community](#community)
- [Credits](#credits)
- [License](#license)

## Features

- Declarative dependency management via asset manifests
- Asset preprocessing/conversion (supports [CoffeeScript](http://coffeescript.org/), [Sass / Scss](http://sass-lang.com/), [Less](http://lesscss.org/), [Erb](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html), etc.)
- Asset compression (supports [YUI Compressor](http://developer.yahoo.com/yui/compressor/), [Closure Compiler](https://developers.google.com/closure/compiler/), etc.)
- Fingerprints bundled asset filenames with MD5 hashes for better browser caching
- Automatic generation of HTML `link` and `script` tags that point to bundled assets
- Integrates seamlessly into Jekyll's workflow, including auto site regeneration

## How It Works

JAPR's workflow can be summarized as follows:

1. Reviews site markup for instances of the `css_asset_tag` and `javascript_asset_tag` Liquid tags. Each occurrence of either of these tags identifies when a new bundle needs to be created and outlines (via a manifest) which assets to include in the bundle.
2. Collects raw assets based on the manifest and runs them through converters / preprocessors (if necessary) to convert them into valid CSS or JavaScript.
3. Combines the processed assets into a single bundle, compresses the bundled assets (if desired) and saves the compressed bundle to the `_site` output folder.
4. Replaces `css_asset_tag` and `javascript_asset_tag` Liquid tags with HTML `link` and `script` tags, respectively, that link to the finished bundles.

## Getting Started

JAPR is extremely easy to add to your Jekyll project and has no incremental dependencies beyond those required by Jekyll. Once you have a basic Jekyll site up and running, follow the steps below to install and configure JAPR.

1. Install the `japr` gem via [Rubygems](http://rubygems.org/).

  ``` bash
  $ gem install japr
  ```

  If you are using [Bundler](http://gembundler.com/) to manage your project's gems, you can just add `japr` to your Gemfile and run `bundle install`.

2. Add a `_plugins` folder to your project if you do not already have one. Within the `_plugins` folder, add a file named `jekyll_asset_pipeline.rb` with the following require statement as its contents.

  ``` ruby
  require 'japr'
  ```

3. Move your assets into a Jekyll ignored folder (i.e. a folder that begins with an underscore `_`) so that Jekyll won't include these raw assets in the site output. It is recommended to use an `_assets` folder to hold your site's assets.

4. Add the following [Liquid](http://liquidmarkup.org/) blocks to your site's HTML `head` section. These blocks will be converted into HTML `link` and `script` tags that point to bundled assets. Within each block is a manifest of assets to include in the bundle. Assets are included in the same order that they are listed in the manifest. Replace the `foo` and `bar` assets with your site's assets. At this point we are just using plain old javascript and css files (hence the `.js` and `.css` extensions). See the [Asset Preprocessing](#asset-preprocessing) section to learn how to include files that must be preprocessed (e.g. CoffeeScript, Sass, Less, Erb, etc.). Name the bundle by including a string after the opening tag. We've named our bundles "global" in the below example.

  ``` html
  {% css_asset_tag global %}
  - /_assets/foo.css
  - /_assets/bar.css
  {% endcss_asset_tag %}

  {% javascript_asset_tag global %}
  - /_assets/foo.js
  - /_assets/bar.js
  {% endjavascript_asset_tag %}
  ```
  Asset manifests must be formatted as YAML arrays and include full paths to each asset from the root of the project. YAML [does not allow tabbed markup](http://www.yaml.org/faq.html), so you must use spaces when indenting your YAML manifest or you will get an error when you compile your site. If you are using assets that must be preprocessed, you should append the appropriate extension (e.g. '.js.coffee', '.css.less') as discussed in the [Asset Preprocessing](#asset-preprocessing) section.

5. Run the `jekyll build` command to compile your site. You should see an output that includes the following JAPR status messages.

  ``` bash
  $ jekyll build
  Generating...
  Asset Pipeline: Processing 'css_asset_tag' manifest 'global'
  Asset Pipeline: Saved 'global-md5hash.css' to 'yoursitepath/assets'
  Asset Pipeline: Processing 'javascript_asset_tag' manifest 'global'
  Asset Pipeline: Saved 'global-md5hash.js' to 'yoursitepath/assets'
  ```

  If you do not see these messages, check that you have __not__ set Jekyll's `safe` option to `true` in your site's `_config.yml`. If the `safe` option is set to `true`, Jekyll will not run plugins.

That is it! You should now have bundled assets. Look in the `_site` folder of your project for an `assets` folder that contains the bundled assets. HTML tags that point to these assets have been placed in the HTML output where you included the Liquid blocks. *You may notice that your assets have not been converted or compressed-- we will add that functionality next.*

## Asset Preprocessing

Asset preprocessing (i.e. conversion) allows us to write our assets in languages such as [CoffeeScript](http://coffeescript.org/), [Sass](http://sass-lang.com/), [Less](http://lesscss.org/), [Erb](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html) or any other language. One of JAPR's key strengths is that it works with __any__ preprocessing library that has a ruby wrapper. Adding a preprocessor is straightforward, but requires a small amount of additional code.

In the following example, we will add a preprocessor that converts CoffeeScript into JavaScript.

### CoffeeScript

1. In the `jekyll_asset_pipeline.rb` file that we created in the [Getting Started](#getting-started) section, add the following code to the end of the file (i.e. after the `require` statement).

  ``` ruby
  module JAPR
      class CoffeeScriptConverter < JAPR::Converter
        require 'coffee-script'

        def self.filetype
          '.coffee'
        end

        def convert
          return CoffeeScript.compile(@content)
        end
      end
  end
  ```

  The above code adds a CoffeeScript converter. You can name a converter anything as long as it inherits from `JAPR::Converter`. The `self.filetype` method defines the type of asset a converter will process (e.g. `.coffee` for CoffeeScript) based on the extension of the raw asset file. A `@content` instance variable that contains the raw content of our asset is made available within the converter. The converter should process this content and return the processed content (as a string) via a `convert` method.

2. If you haven't already, you should now install any dependancies that are required by your converter. In our case, we need to install the `coffee-script` gem.

  ``` bash
  $ gem install coffee-script
  ```

  If you are using [Bundler](http://gembundler.com/) to manage your project's gems, you can just add `coffee-script` to your Gemfile and run `bundle install`.

3. Append a `.coffee` extension to the filename of any asset that should be converted with the `CoffeeScriptConverter`. For example, `foo.js` would become `foo.js.coffee`.

4. Run the `jekyll build` command to compile your site.

That is it! Your asset pipeline has converted any CoffeeScript assets into JavaScript before adding them to a bundle.

### SASS / SCSS

You probably get the gist of how converters work, but here's an example of a SASS converter for quick reference.

``` ruby
module JAPR
  class SassConverter < JAPR::Converter
    require 'sass'

    def self.filetype
      '.scss'
    end

    def convert
      return Sass::Engine.new(@content, syntax: :scss).render
    end
  end
end
```

Don't forget to install the `sass` gem or add it to your Gemfile and run `bundle install` before you run the `jekyll build` command since the above SASS converter requires the `sass` library as a dependency.

If you're using `@import` statements in your SASS files, you'll probably need to specify a base load path to the SASS engine in your `convert` method.
You can use the `@dirname` instance variable for this, which contains the path to the current asset's directory:

``` ruby
...
    def convert
      return Sass::Engine.new(@content, syntax: :scss, load_paths: [@dirname]).render
    end
...
```

### LESS

``` ruby
module JAPR
  class LessConverter < JAPR::Converter
    require 'less'

    def self.filetype
      '.less'
    end

    def convert
      return Less::Parser.new.parse(@content).to_css
    end
  end
end
```

Don't forget to install the `less` gem or add it to your Gemfile and run `bundle install` before you run the `jekyll build` command since the above LESS converter requires the `less` library as a dependency.

As with the SASS convertor, you'll probably need to specify a base load path and pass that to the LESS Parser:

``` ruby
...
    def convert
      return Less::Parser.new(paths: [@dirname]).parse(@content).to_css
    end
...
```

### Successive Preprocessing

If you would like to run an asset through multiple preprocessors successively, you can do so by naming your assets with nested file extensions. Nest the extensions in the order (right to left) that the asset should be processed. For example, `.css.scss.erb` would first be processed by an `erb` preprocessor then by a `scss` preprocessor before being rendered. This convention is very similar to the convention used by the [Ruby on Rails asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html#preprocessing).

Don't forget to define preprocessors for the extensions you use in your filenames, otherwise JAPR will not process your asset.

## Asset Compression

Asset compression allows us to decrease the size of our assets and increase the speed of our site. One of JAPR's key strengths is that it works with __any__ compression library that has a ruby wrapper. Adding asset compression is straightforward, but requires a small amount of additional code.

In the following example, we will add a compressor that uses Yahoo's YUI Compressor to compress our CSS and JavaScript assets.

### Yahoo's YUI Compressor

1. In the `jekyll_asset_pipeline.rb` file that we created in the [Getting Started](#getting-started) section, add the following code to the end of the file (i.e. after the `require` statement).

  ``` ruby
  module JAPR
    class CssCompressor < JAPR::Compressor
      require 'yui/compressor'

      def self.filetype
        '.css'
      end

      def compress
        return YUI::CssCompressor.new.compress(@content)
      end
    end

    class JavaScriptCompressor < JAPR::Compressor
      require 'yui/compressor'

      def self.filetype
        '.js'
      end

      def compress
        return YUI::JavaScriptCompressor.new(munge: true).compress(@content)
      end
    end
  end
  ```

  The above code adds a CSS and a JavaScript compressor. You can name a compressor anything as long as it inherits from `JAPR::Compressor`. The `self.filetype` method defines the type of asset a compressor will process (either `'.js'` or `'.css'`). The `compress` method is where the magic happens. A `@content` instance variable that contains the raw content of our bundle is made available within the compressor. The compressor should process this content and return the processed content (as a string) via a `compress` method.

2. If you haven't already, you should now install any dependencies that are required by your compressor. In our case, we need to install the `yui-compressor` gem.

  ``` bash
  $ gem install yui-compressor
  ```

  If you are using [Bundler](http://gembundler.com/) to manage your project's gems, you can just add `yui-compressor` to your Gemfile and run `bundle install`.

3. Run the `jekyll build` command to compile your site.

That is it! Your asset pipeline has compressed your CSS and JavaScript assets. You can verify that this is the case by looking at the contents of the bundles generated in the `_site/assets` folder of your project.

### Google's Closure Compiler

You probably get the gist of how compressors work, but here's an example of a Google Closure Compiler compressor for quick reference.

``` ruby
class JavaScriptCompressor < JAPR::Compressor
  require 'closure-compiler'

  def self.filetype
    '.js'
  end

  def compress
    return Closure::Compiler.new.compile(@content)
  end
end
```

Don't forget to install the `closure-compiler` gem before you run the `jekyll build` command since the above compressor requires the `closure-compiler` library as a dependency.

## Templates

When JAPR creates a bundle, it returns an HTML tag that points to the bundle. This tag is either a `link` tag for CSS or a `script` tag for JavaScript. Under most circumstances the default tags will suffice, but you may want to customize this output for special cases (e.g. if you want to add a CSS media attribute).

In the following example, we will override the default CSS link tag by adding a custom template that produces a link tag with a `media` attribute.

1. In the `jekyll_asset_pipeline.rb` file that we created in the [Getting Started](#getting-started) section, add the following code.

  ``` ruby
  module JAPR
    class CssTagTemplate < JAPR::Template
      def self.filetype
        '.css'
      end

      def html
        "<link href='/#{@path}/#{@filename}' rel='stylesheet'" \
          "type='text/css' media='screen' />\n"
      end
    end
  end
  ```

  If you already added a compressor and/or a converter, you can include your template class alongside your compressor and/or converter within the same JAPR module.

  The “self.filetype” method defines the type of bundle a template will target (either `.js` or `.css`). The “html” method is where the magic happens. “@path” and `@filename` instance variables are available within the class and contain the path and filename of the generated bundle, respectively. The template should return a string that contains an HTML tag pointing to the generated bundle via an `html` method.

2. Run the `jekyll` command to compile your site.

That is it! Your asset pipeline used your template to generate an HTML `link` tag that includes a media attribute with the value `screen`. You can verify that this is the case by viewing the generated source within your project's `_site` folder.

## Configuration

JAPR provides the following configuration options that can be controlled by adding them to your project's `_config.yml` file. If you don't have a `_config.yml` file, consider reading the [configuration section](https://github.com/mojombo/jekyll/wiki/Configuration) of the Jekyll documentation.

``` yaml
asset_pipeline:
  bundle: true
  compress: true
  output_path: assets
  display_path: nil
  gzip: false
```

Setting        | Default  | Description
---------------|----------|-----------------------------------------------------
`bundle`       | `true`   | controls whether JAPR bundles the assets defined in each manifest. If set to `false`, each asset will be saved individually and individual html tags pointing to each unbundled asset will be produced when you compile your site. It is useful to set this to `false` while you are debugging your site.
`compress`     | `true`   | tells JAPR whether or not to compress the bundled assets. It is useful to set this setting to `false` while you are debugging your site.
`output_path`  | `assets` | defines where generated bundles should be saved within the `_site` folder of your project.
`display_path` | `nil`    | overrides the path to assets in generated html tags. This is useful if you are hosting your site at a path other than the root of your domain (e.g. `http://example.com/blog/`).
`gzip`         | `false`  | controls whether JAPR saves gzipped versions of your assets alongside un-gzipped versions.


## Octopress

[Octopress](http://octopress.org/) is a popular framework for Jekyll that can help you get a blog up and running quickly. JAPR can be added to an Octopress site using the [Getting Started](#getting-started) steps above with the following modifications:

1. Octopress uses Bundler to manage your site's dependencies. You should add `gem japr` to your Gemfile and then run `bundle install` to install.

2. Instead of adding a `_plugins` folder, you should put `jekyll_asset_pipeline.rb` in the `plugins` folder included by default in the root of your Octopress site.

3. You should still store your assets in an Jekyll ignored folder (i.e. a folder that begins with an underscore `_`), but note that this folder should be located within the `source` folder of your Octopress site (e.g. `source/_assets`).

4. No change to this step.

5. Instead of running the `jekyll` command to compile your site, you should use Octopress' rake commands (e.g. `rake generate`) as outlined [here](http://octopress.org/docs/blogging/).

If you have any difficulties using JAPR with Octopress, please [open an issue](http://github.com/kitsched/japr/issues).

## Contribute

You can contribute to the JAPR by submitting a pull request [via GitHub](https://github.com/kitsched/japr). There are a few areas that need improvement:

- __Tests, tests, tests.__ **This project is now almost fully tested.**
- __Handle remote assets.__ Right now, JAPR does not provide any way to include remote assets in bundles unless you save them locally before generating your site. Moshen's [Jekyll Asset Bundler](https://github.com/moshen/jekyll-asset_bundler) allows you to include remote assets, which is pretty interesting. That said, it is generally better to keep remote assets separate so that they load asynchronously.
- __Successive preprocessing.__ Currently you can only preprocess a file once. It would be better if you could run an asset through multiple preprocessors before it gets compressed and bundled. **As of v0.1.0, JAPR now supports successive preprocessing.**

If you have any ideas or you would like to see anything else improved please use the [issues section](https://github.com/kitsched/japr/issues).

## Community

- Here is a list of [sites that use JAPR](http://github.com/kitsched/japr/wiki/Sites-that-use-JAPR). Feel free to add your site to the list if you want.

## Credits

* [Moshen](https://github.com/moshen/) for creating the [Jekyll Asset Bundler](https://github.com/moshen/jekyll-asset_bundler).
* [Mojombo](https://github.com/mojombo) for creating [Jekyll](https://github.com/mojombo/jekyll) in the first place.

## License

JAPR is released under the [MIT License](http://opensource.org/licenses/MIT).
