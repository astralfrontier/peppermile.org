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
markdown        = require 'metalsmith-markdown'
metadata        = require 'metalsmith-metadata'
more            = require 'metalsmith-more'
pagination      = require 'metalsmith-pagination'
path            = require 'metalsmith-path'
serve           = require 'metalsmith-serve'
tags            = require 'metalsmith-tags'
typography      = require 'metalsmith-typography'
yaml            = require 'metalsmith-yaml'

fs = require 'fs'
main_bower_files = require 'main-bower-files'
node_path = require 'path'

bower_plugin = (options) ->
  (files, metalsmith, done) ->
    for file in main_bower_files(options)
      type = switch node_path.extname(file)
        when '.css' then 'css'
        when '.js' then 'js'
        when '.otf' then 'fonts'
        when '.eot' then 'fonts'
        when '.svg' then 'fonts'
        when '.ttf' then 'fonts'
        when '.woff' then 'fonts'
        when '.woff2' then 'fonts'
        else 'skip'
      if type != 'skip'
        dest = "#{type}/#{node_path.basename(file)}"
        contents = String(fs.readFileSync(file))
        files[dest] = { contents: contents }
    done()

collection_data = {
  blog:
    sortBy: 'date'
    reverse: true
}

pagination_data = {
  'collections.blog':
    perPage: 10
    layout: 'bloglist.jade'
    first: 'index.html'
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
  .use(markdown({
    smartypants: true
    gfm: true
    tables: true
  }))
  .use(yaml({}))
  .use(inPlace({
    engine: 'handlebars'
    partials: 'partials'
  }))
  .use(typography({
    lang: 'en'
  }))
# .use(bower_plugin({}))
  .use(path())
  .use(more({
    alwaysAddKey: true
  }))
  .use(tags({
    handle: 'tagged'
    sortBy: 'date'
    reverse: true
    layout: 'tag.jade'
    path: 'tag/:tag.html'
    pathPage: 'tag/:tag-:num.html'
    perPage: 12
  }))
  .use(layouts({
    engine: 'jade'
    directory: 'layouts'
    partials: 'partials'
    default: 'article.jade'
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
