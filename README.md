Shadowbox
=========

This is a theme for the [Jekyll][] site generator which supports the following common blog features:

- Tags (via "tags" metadata in a post)
- Categories (using subdirectories, untested with "categories" metadata)
- Intelligent capitalization for tags/categories (to enforce consistency). Put exceptions in `_plugins/special-cases.txt`.
- Atom feeds
- Monthly and yearly archive pages
- [Disqus][] comments
- Automatic post summaries (if the [Nokogiri][] and [htmlentities][] gems are installed)
- Manual post summaries by ending a paragraph with `<--more-->`
- Hiding things from the front page and main newsfeed (using `no_news: true`)
- `include`-ing files to be processed by a converter
- `highlight`-ing Markdown code blocks (i.e. you can indent Liquid-highlighted code, so it looks better in a Markdown or Textile context)
- Supports my [dependency-aware Jekyll fork][dependencies].
- Includes support for SSI using `uses_ssi: true`.
- Post directories. Instead of naming your post `YYYY-MM-DD-Title.md`, you can make a directory named `YYYY-MM-DD-Title/` and anything inside it will be copied to the proper place. (You probably want to put an `index.markdown` or `index.textile` inside that folder.)

	You may want to install the [ptools][] gem so that Shadowbox can guess if a file is binary and shouldn't be processed by Liquid.
- An "everything" archive page with live (client-side) search on the content. (This probably won't scale but that's not my problem right now. \*grin\*)

It is designed so that new users should have to edit as few files as possible:

- `_config.yml`
- `_includes/head.html`
- `_includes/blurb.md`
- `_includes/footer.md`
- `images/blog-banner.png` (width: 246px)
- `images/logo.png` (48x48px)
- `index.html`

To see Shadowbox in action, check out <http://belkadan.com/blog>.

Shadowbox was (very) loosely based on the Kubrick theme for WordPress.
A couple of the plugins were created by [Jose Diaz-Gonzalez][jdg], then modified for this site. The client-side search was created by [Elijah Miller][em].

Created by Jordy Rose  
<http://belkadan.com>  
<jrose@belkadan.com>

  [jekyll]: https://github.com/mojombo/jekyll
  [disqus]: http://disqus.com
  [nokogiri]: http://nokogiri.org
  [htmlentities]: http://htmlentities.rubyforge.org
  [dependencies]: https://github.com/belkadan/jekyll
  [ptools]: http://rubygems.org/gems/ptools
  [jdg]: https://github.com/josegonzalez/josediazgonzalez.com/tree/master/_plugins
  [em]: https://github.com/jqr/jqr.github.com

---

License
-------
(for what I hold copyright to)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or other
dealings in this Software without prior authorization.

