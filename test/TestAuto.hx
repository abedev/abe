import utest.Assert;
import routes.*;
import js.node.http.Method;

class TestAuto extends TestCalls {
  public function testAuto() {
    router.register(new Auto());

    request("/auto/", Get, function(msg) {
      Assert.equals('DONE', msg);
    });

    request("/auto/", Post, {foo: 'bar'}, function(msg : String) {
      Assert.equals('POSTED', msg);
    });
  }

  // test things like the @:all route, which handles all HTTP verbs, as well as
  // setting up multiple route metadata for a single handler function
  public function testMultiRouteHandler() {
    router.register(new Auto());

    // make sure the @:all route can handle a variety of http methods
    request("/handle/everything/", Get, function(msg : String) {
      Assert.equals(Get, msg);
    });

    request("/handle/everything/", Post, function(msg : String) {
      Assert.equals(Post, msg);
    });

    request("/handle/everything/", Delete, function(msg : String) {
      Assert.equals(Delete, msg);
    });

    // attaching multiple meta methods to the same handler should cause that
    // handler to run for multiple paths or methods
    request("/multi/meta/foo", Put, function(msg : String) {
      Assert.equals("HANDLE MULTIPLE", msg);
    });

    request("/multi/meta/foo", Post, function(msg : String) {
      Assert.equals("HANDLE MULTIPLE", msg);
    });
  }

  public function testMount() {
    var sub = router.mount("/sub/");
    sub.register(new Auto());

    request("/sub/auto/", Get, function(msg) {
      Assert.equals('DONE', msg);
    });
  }
}