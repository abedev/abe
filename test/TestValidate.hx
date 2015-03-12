import express.Error;
import express.Next;
import express.Request;
import express.Response;
import routes.*;
import utest.Assert;

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

    get("/validate/quick/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/validate/quick/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });

    get("/validate/quicker/9", function (msg, _) {
        Assert.equals("9", msg);
      });

    get("/validate/quicker/3", function (msg, res) {
        Assert.equals(400, res.statusCode);
        Assert.notEquals("3", msg);
      });

    get("/validate/quickermixed/9/0/0.6", function (msg, _) {
        Assert.equals("9 0 0.6", msg);
      });

    get("/validate/quickermixed/9/1/0.6", function (msg, res) {
        Assert.equals(400, res.statusCode);
      });

    get("/validate/quickermixed/9/0/0.5", function (msg, res) {
        Assert.equals(400, res.statusCode);
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
  @:validate(null, function (age : Int, req : Request, res : Response, next : Next) {
    if (age == 9) next.call();
    else res.sendStatus(400);
  })
  function validateAge(name : String, age : Int) {
    response.send('$age');
  }

  @:get("/quick/:id")
  @:validate(function(id) return id == 9)
  @:error(Validate.hideError)
  function quickValidate(id : Int) {
    response.send('$id');
  }

  @:get("/quicker/:id")
  @:validate(_ == 9)
  @:error(Validate.hideError)
  function quickerValidate(id : Int) {
    response.send('$id');
  }

  // This was failing at compile time
  @:get("/quickermixed/:id/:zero/:f")
  @:validate(_ == 9, _ == "0", _ > 0.5)
  @:error(Validate.hideError)
  function quickerMixedValidate(id : Int, zero : String, f : Float) {
    response.send('$id $zero $f');
  }

  public static function hideError(err : Error, req : Request, res : Response, next : Next)
    if(err.status == 400)
      res.sendStatus(400);
}
