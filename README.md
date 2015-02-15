# restx
Build REST apis with Haxe and nodejs.

WARNING: this is an experimental project and might be dropped at any time.

TODO:
  * parse and validate parameters
    * custom validators

  * integrations
    * passport
    * acl (@:role)

  * support verbs through metas
    @:all/@:get/@:post/@:put/@:options/@:head/@:delete

  * set name meta to enable forwarding?
    @:name("string") // for forwarding to next("string")

  * add versioning?
    @:version("1.1.3")

  * add meta to specify parameters sources
    function list(@:from(Query) page = 1)

  * move DynamicRouteProcess to core (or eliminate?)
  * better naming for classes
  * add sub-apps

  * [middleware](http://expressjs.com/resources/middleware.html)
    * body parser
    * compression
    * cookie-parser
    * cookie-session
    * csrf
    * error handler
    * express debug
    * partial response?
    * session
    * cdn ?
    * slash ?
    * uncapitalize ? case sensitive?
    * method override
    * logging (morgan)
    * response time
    * favicon
    * index
    * static
    * vhost ?
    * view helpers
    * multipart
    * query string
    * static cache
    * expose https://github.com/expressjs/express-expose
    * flash message https://github.com/expressjs/flash
    * image optimizer https://github.com/msemenistyi/connect-image-optimus?_ga=1.71656337.300478207.1423933963