import utest.Assert;

class TestUse extends TestCalls {
  public function testUse() {
    router.register(new Use());

    get("/use/cls", function(msg, _) {
      Assert.equals('CLASS', msg);
    });

    get("/use/fun", function(msg, _) {
      Assert.equals('FUNCTION', msg);
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