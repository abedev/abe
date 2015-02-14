package routes;

import restx.IRoute;

class Index implements IRoute {
  public var request : Dynamic;
  public var response : Dynamic;
  public function new() {}

  public function manual() {
    response.send("Hello World");
  }

  /*
    // passport
    // server.render ?
    // capture app error
    // capture HttpErrors

    @:get/@:post/@:put/@:options/@:head/@:delete
    @:method(a,b,c)

    @:path("/")

    @:param("name", String) // not needed, can be inferred

    @:name("string") // for forwarding to next("string")

    @:version("1.1.3")

    @:role()
  */
}