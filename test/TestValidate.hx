import utest.Assert;
import routes.*;

class TestValidate extends TestCalls {
  public function testValidation() {
    router.register(new Validate());

    get("/validate/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/validate/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });

    get("/validate/franco/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/validate/franco/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });
  }
}
