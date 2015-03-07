import utest.Assert;
import routes.*;
import js.node.http.Method;

class TestAuto extends TestCalls {
  public function testAuto() {
    router.register(new Auto());

    get("/auto/", function(msg, _) {
      Assert.equals('DONE', msg);
    });

    post("/auto/", {foo: 'bar'}, function(msg : String, _) {
      Assert.equals('POSTED', msg);
    });
  }

  // test things like the @:all route, which handles all HTTP verbs, as well as
  // setting up multiple route metadata for a single handler function
  public function testMultiRouteHandler() {
    router.register(new Auto());

    // make sure the @:all route can handle a variety of http methods
    get("/handle/everything/", function(msg : String, _) {
      Assert.equals(Get, msg);
    });

    post("/handle/everything/", {}, function(msg : String, _) {
      Assert.equals(Post, msg);
    });

    delete("/handle/everything/", function(msg : String, _) {
      Assert.equals(Delete, msg);
    });

    // attaching multiple meta methods to the same handler should cause that
    // handler to run for multiple paths or methods
    put("/multi/meta/foo", {}, function(msg : String, _) {
      Assert.equals("HANDLE MULTIPLE", msg);
    });

    post("/multi/meta/foo", {}, function(msg : String, _) {
      Assert.equals("HANDLE MULTIPLE", msg);
    });
  }

  public function testMount() {
    var sub = router.mount("/sub/");
    sub.register(new Auto());

    get("/sub/auto/", function(msg, _) {
      Assert.equals('DONE', msg);
    });
  }
}

class Auto implements abe.IRoute {
  @:get("/auto/")
  function noParams() {
    response.send("DONE");
  }

  @:post("/auto/")
  function noParamPost() {
    response.send("POSTED");
  }

  @:get("/auto/:name/:age")
  function withParams(name : String, age : Int) {
    Assert.is(name, String);
    Assert.is(age, Int);
    response.send({name:name,age:age});
  }

  @:put("/multi/meta/foo")
  @:post("/multi/meta/foo")
  function handleMultiple() {
    response.send("HANDLE MULTIPLE");
  }

  @:all("/handle/everything")
  function handleEverything() {
    response.send(request.method);
  }
}
