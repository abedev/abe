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

@:path("/validate/")
class Validate implements abe.IRoute {
  @:get("/:id")
  @:validate(function (id : Int, req : express.Request, res : express.Response, next : express.Next) {
      if (id == 9) next.call();
      else res.sendStatus(400);
    })
  function getById(id : Int) {
    response.send('$id');
  }

  @:get("/:name/:age")
  @:validate(null, function (age : Int, req : express.Request, res : express.Response, next : express.Next) {
    if (age == 9) next.call();
    else res.sendStatus(400);
  })
  function validateAge(name : String, age : Int) {
    response.send('$age');
  }
}
