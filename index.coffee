metalsmith      = require 'metalsmith'
assets          = require 'metalsmith-assets'
beautify        = require 'metalsmith-beautify'
collections     = require 'metalsmith-collections'
dateInFilename  = require 'metalsmith-date-in-filename'
drafts          = require 'metalsmith-drafts'
feed            = require 'metalsmith-feed'
inPlace         = require 'metalsmith-in-place'
jquery          = require 'metalsmith-jquery'
layouts         = require 'metalsmith-layouts'
less            = require 'metalsmith-less'
link_checker    = require 'metalsmith-broken-link-checker'
markdownit      = require 'metalsmith-markdownit'
metadata        = require 'metalsmith-metadata'
more            = require 'metalsmith-more'
open_graph      = require 'metalsmith-open-graph'
pagination      = require 'metalsmith-pagination'
path            = require 'metalsmith-path'
pug             = require 'metalsmith-pug'
serve           = require 'metalsmith-serve'
typography      = require 'metalsmith-typography'
yaml            = require 'metalsmith-yaml'

collection_data = {
  blog:
    sortBy: 'date'
    reverse: true
}

pagination_data = {
  'collections.blog':
    perPage: 10
    layout: 'bloglist.jade'
    first: 'blog.html'
    path: 'blog/:num.html'
}

metalsmith(__dirname)
  .use(metadata({
    'links': 'links.yaml'
    'menu': 'menu.yaml'
    'site': 'site.yaml'
  }))
  .use(drafts())
  .use(dateInFilename(true))
  .use(collections(collection_data))
  .use(pagination(pagination_data))
  .use(pug({
    pretty: true
  }))
  .use(markdownit({
      html: true
    }).use(require('markdown-it-toc')).use(require('markdown-it-attrs')))
  .use(yaml({}))
  .use(inPlace({
    engine: 'handlebars'
    partials: 'partials'
  }))
  .use(typography({
    lang: 'en'
  }))
  .use(path())
  .use(more({
    alwaysAddKey: true
  }))
  .use(layouts({
    engine: 'jade'
    directory: 'layouts'
    partials: 'partials'
    default: 'article.jade'
  }))
  .use(open_graph({
    pattern: '**/*.html'
    siteurl: 'http://peppermile.com/'
    description: 'description'
    image: '.og-image'
  }))
  .use(jquery(($) ->
    # All external links should open in new windows
    $('a[href^="http://"]').attr("target", "_blank")
    $('a[href^="https://"]').attr("target", "_blank")
  ))
  .use(feed(collection: 'blog'))
  .use(beautify({
    html: { wrap_line_length: 80 }
  }))
  .use(assets({
    source: './assets'
    destination: './assets'
  }))
  .use(less({}))
  .use(link_checker({warn: true}))
  .destination('./build')
# .use(serve({
#   host: '0.0.0.0'
#   port: 3000
# }))
  .build (err, files) ->
    if err
      console.error err.stack
      process.exit(1)
