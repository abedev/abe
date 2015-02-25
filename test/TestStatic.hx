import utest.Assert;
import routes.*;

class TestStatic extends TestCalls {
  public function testFromQS() {
    router.serve("/public/", ".");

    get("/public/haxelib.json", function(msg) {
      Assert.notNull(msg);
    });
  }
}
