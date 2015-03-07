import utest.Assert;
import routes.*;

class TestValidate extends TestCalls {
  public function testValidation() {
    router.register(new Validate());

    get("/validate/id/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/validate/id/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });

    get("/validate/name/franco/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/validate/name/franco/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });

    get("/quick/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/quick/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });

    get("/quicker/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/quicker/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });
  }
}

@:path("/validate/")
class Validate implements abe.IRoute {
  @:get("/id/:id")
  @:validate(function (id : Int, req : express.Request, res : express.Response, next : express.Next) {
      if (id == 9) next.call();
      else res.sendStatus(400);
    })
  function getById(id : Int) {
    response.send('$id');
  }

  @:get("/name/:name/:age")
  @:validate(null, function (age : Int, req : express.Request, res : express.Response, next : express.Next) {
    if (age == 9) next.call();
    else res.sendStatus(400);
  })
  function validateAge(name : String, age : Int) {
    response.send('$age');
  }

/*
  @:get("/quick/:id")
  @:validate(function(id) return id == 9)
  function quickValidate(id : Int) {
    response.send('$id');
  }
*/

/*
  @:get("/quicker/:id")
  @:validate(_ == 9)
  function quickerValidate(id : Int) {
    response.send('$id');
  }
*/
}
