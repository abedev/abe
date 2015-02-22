import utest.Assert;
import routes.*;
import js.node.http.Method;

class TestParam extends TestCalls {
  public function testFromQS() {
    router.register(new Param());

    request("/list/", Get, function(msg) {
      Assert.equals('page: 1', msg);
    });

    request("/list/?page=2", Get, function(msg) {
      Assert.equals('page: 2', msg);
    });

    request("/list2/some/?page=2", Get, function(msg) {
      Assert.equals('some: 2', msg);
    });
  }
}
