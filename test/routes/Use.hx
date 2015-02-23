package routes;

import utest.Assert;

@:path("/use/")
@:use(routes.Use.add("cls", "CLASS"))
class Use implements abe.IRoute {
  @:get("/cls")
  function useClass()
    response.send(Reflect.field(request, "cls"));

  @:get("/fun")
  @:use(routes.Use.add("fun", "FUNCTION"))
  function useInst()
    response.send(Reflect.field(request, "fun"));

  public static function add(key : String, value : String) {
    return function(req, res, next) {
      Reflect.setField(req, key, value);
      next();
    };
  }
}
