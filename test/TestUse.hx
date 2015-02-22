import utest.Assert;
import routes.*;
import js.node.http.Method;

class TestUse extends TestCalls {
  public function testUse() {
    router.register(new Use());

    request("/use/cls", Get, function(msg) {
      Assert.equals('CLASS', msg);
    });

    request("/use/fun", Get, function(msg) {
      Assert.equals('FUNCTION', msg);
    });
  }
}
