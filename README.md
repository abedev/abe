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
