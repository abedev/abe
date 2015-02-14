package routes;

import utest.Assert;

import express.Next;
import express.Request;
import express.Response;
import restx.IRoute;

class Manual implements IRoute {
  public var request : Request;
  public var response : Response;
  public var next : Next;
  public function new() {}

  public function noArgs() {
    response.send("Hello World");
  }

  public function withArgs(i : Int, b : Bool, s : String) {
    Assert.is(i, Int);
    Assert.is(b, Bool);
    Assert.is(s, String);
    response.send({ i : i, b : b, s : s });
  }

  public function withOptionalArg(?i : Int, b : Bool) {
    if(null != i)
      Assert.is(i, Int);
    Assert.is(b, Bool);
    response.send({ i : i, b : b });
  }

  /*
    // passport
    // server.render ?
    // capture app error
    // capture HttpErrors

    @:all/@:get/@:post/@:put/@:options/@:head/@:delete
    @:method(a,b,c)

    @:path("/")

    @:forward("string") // for forwarding to next("string")

    @:version("1.1.3")

    @:role()

    function list(@:from(Query) page = 1)
  */
}