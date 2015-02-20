package restx;
import restx.Method;

#if macro
import haxe.macro.Expr;
#else
import express.Express;
import express.Router in R;
import haxe.Constraints.Function;
#end

class Router {
#if !macro
  var router : R;
  public function new(router : R) {
    this.router = router;
  }

  public function mount(path : String) {
    var newrouter = new R();
    router.use(path, newrouter);
    return new Router(newrouter);
  }

  public function registerMethod(path : String, method : Method, process : RouteProcess<IRoute, {}>) {
    if(null == method)
      method = Get;

    Reflect.callMethod(
      router,
      Reflect.field(router, (method : String).toLowerCase()), [
        path,
        process.run
      ]
    );
  }
#end
  macro public function register(_this : Expr, instance : Expr)
    return restx.core.macros.AutoRegisterRoute.register(_this, instance);
}