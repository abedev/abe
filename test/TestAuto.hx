import utest.Assert;
import routes.*;
import js.node.http.Method;

class TestAuto extends TestCalls {
  public function testAuto() {
    router.register(new Auto());

    get("/auto/", function(msg) {
      Assert.equals('DONE', msg);
    });

    post("/auto/", {foo: 'bar'}, function(msg : String) {
      Assert.equals('POSTED', msg);
    });
  }

  // test things like the @:all route, which handles all HTTP verbs, as well as
  // setting up multiple route metadata for a single handler function
  public function testMultiRouteHandler() {
    router.register(new Auto());

    // make sure the @:all route can handle a variety of http methods
    get("/handle/everything/", function(msg : String) {
      Assert.equals(Get, msg);
    });

    post("/handle/everything/", {}, function(msg : String) {
      Assert.equals(Post, msg);
    });

    delete("/handle/everything/", function(msg : String) {
      Assert.equals(Delete, msg);
    });

    // attaching multiple meta methods to the same handler should cause that
    // handler to run for multiple paths or methods
    put("/multi/meta/foo", {}, function(msg : String) {
      Assert.equals("HANDLE MULTIPLE", msg);
    });

    post("/multi/meta/foo", {}, function(msg : String) {
      Assert.equals("HANDLE MULTIPLE", msg);
    });
  }

  public function testMount() {
    var sub = router.mount("/sub/");
    sub.register(new Auto());

    get("/sub/auto/", function(msg) {
      Assert.equals('DONE', msg);
    });
  }
}
