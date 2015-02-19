import utest.Assert;
import routes.*;

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
    // make sure the @:all route can handle a variety of http methods
    request("/handle/everything/", Get, function(msg : String) {
      Assert.equals(Get, msg);
    });

    request("/handle/everything/", Post, function(msg : String) {
      Assert.equals(Post, msg);
    });

    request("/handle/everything/", Delete, function(msg : String) {
      Assert.equals(Delete, msg);
  }

  public function testMount() {
    var sub = router.mount("/sub/");
    sub.register(new Auto());

    request("/sub/auto/", Get, function(msg) {
      Assert.equals('DONE', msg);
    });
  }
}