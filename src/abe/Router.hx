package abe;
import abe.Method;

#if macro
import haxe.macro.Expr;
#else
import express.Express;
import express.Middleware;
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

  public function use(?path : String, middleware : Middleware) {
    if(null == path)
      router.use(middleware);
    else
      router.use(path, middleware);
  }

  public function registerMethod(path : String, method : Method, process : RouteProcess<IRoute, {}>) {
    Reflect.callMethod(
      router,
      Reflect.field(router, method), [
        path,
        process.run
      ]
    );
  }
#end
  macro public function register(_this : Expr, instance : Expr)
    return abe.core.macros.AutoRegisterRoute.register(_this, instance);
}
