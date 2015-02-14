package routes;

import express.Next;
import express.Request;
import express.Response;
import restx.IRoute;

class Index implements IRoute {
  public var request : Request;
  public var response : Response;
  public var next : Next;
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