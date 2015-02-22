import utest.Assert;
import routes.*;

class TestPath extends TestCalls {
  public function testPath() {
    router.register(new Path());

    get("/some/prefix/list/", function(msg) {
      Assert.equals('LIST', msg);
    });

    get("/some/prefix/", function(msg) {
      Assert.equals('INDEX', msg);
    });
  }
}
