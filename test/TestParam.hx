import utest.Assert;
import routes.*;

class TestParam extends TestCalls {
  public function testFromQS() {
    router.register(new Param());

    get("/list/", function(msg) {
      Assert.equals('page: 1', msg);
    });

    get("/list/?page=2", function(msg) {
      Assert.equals('page: 2', msg);
    });

    get("/list2/some/?page=2", function(msg) {
      Assert.equals('some: 2', msg);
    });
  }
}
