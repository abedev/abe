import utest.Assert;
import routes.*;
import js.node.http.Method;

class TestPath extends TestCalls {
  public function testPath() {
    router.register(new Path());

    request("/some/prefix/list/", Get, function(msg) {
      Assert.equals('LIST', msg);
    });

    request("/some/prefix/", Get, function(msg) {
      Assert.equals('INDEX', msg);
    });
  }
}
