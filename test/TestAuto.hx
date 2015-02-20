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

  public function testMount() {
    var sub = router.mount("/sub/");
    sub.register(new Auto());

    request("/sub/auto/", Get, function(msg) {
      Assert.equals('DONE', msg);
    });
  }
}