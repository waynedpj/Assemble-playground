---
title: LoDash Test

## tests
fromLoDash:
  title: <%= title %>
  src: <%= this.src %>
  dirname: sdfsf<%= dirname %>
---
##from Handlebars
title = {{title}}
src = {{page.src}}
dirname = {{dirname}}
{{log dirname}}

##fromLoDash
title = {{fromLoDash.title}}
src = {{fromLoDash.src}}
dirname = {{fromLoDash.dirname}}
{{log fromLoDash.dirname}}
