import utest.Assert;
import routes.*;

class TestUse extends TestCalls {
  public function testUse() {
    router.register(new Use());

    get("/use/cls", function(msg) {
      Assert.equals('CLASS', msg);
    });

    get("/use/fun", function(msg) {
      Assert.equals('FUNCTION', msg);
    });
  }
}
