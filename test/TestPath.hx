import utest.Assert;
import routes.*;

class TestPath extends TestCalls {
  public function testPath() {
    router.register(new Path());

    get("/some/prefix/list/", function(msg, _) {
      Assert.equals('LIST', msg);
    });

    get("/some/prefix/", function(msg, _) {
      Assert.equals('INDEX', msg);
    });
  }
}
