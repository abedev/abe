import utest.Assert;

class TestUse extends TestCalls {
  public function testUse() {
    router.register(new Use());
    router.register(new ClassMiddleware());
    router.register(new ClassMiddleware2());

    get("/use/cls", function(msg, _) {
      Assert.equals('CLASS', msg);
    });

    get("/use/fun", function(msg, _) {
      Assert.equals('FUNCTION', msg);
    });

    get("/class-mw/foo", function (msg, res) {
      Assert.equals(400, res.statusCode);
      Assert.equals("Foo!", msg);
    });

    get("/class-mw2/foo", function (msg, res) {
      Assert.equals(400, res.statusCode);
      Assert.equals("Foo!", msg);
    });
  }
}

@:path("/use/")
@:use(Use.add("cls", "CLASS"))
class Use implements abe.IRoute {
  @:get("/cls")
  function useClass()
    response.send(Reflect.field(request, "cls"));

  @:get("/fun")
  @:use(Use.add("fun", "FUNCTION"))
  function useInst()
    response.send(Reflect.field(request, "fun"));

  public static function add(key : String, value : String) {
    return function(req : express.Request, res : express.Response, next : express.Next) {
      Reflect.setField(req, key, value);
      next.call();
    };
  }
}

@:path("/class-mw")
@:use(function (req, res, next) {
  next();
})
@:use(function (req, res, next) {
  res.status(400).send("Foo!");
})
class ClassMiddleware implements abe.IRoute {
  @:get("/foo")
  function neverGetHere() {
    // the class-level middleware should prevent us from ever getting here
    response.sendStatus(200);
  }
}

@:path("/class-mw2")
@:use(
  function (req, res, next) next(),
  function (req, res, next) res.status(400).send("Foo!"))
class ClassMiddleware2 implements abe.IRoute {
  @:get("/foo")
  function neverGetHere() {
    // the class-level middleware should prevent us from ever getting here
    response.sendStatus(200);
  }
}
