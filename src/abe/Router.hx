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
  public var expressRouter(default, null) : R;
  public function new(expressRouter : R) {
    this.expressRouter = expressRouter;
  }

  public function mount(path : String) {
    var newrouter = new R();
    expressRouter.use(path, newrouter);
    return new Router(newrouter);
  }

  public function use(?path : String, middleware : Middleware) {
    if(null == path)
      expressRouter.use(middleware);
    else
      expressRouter.use(path, middleware);
  }

  public function registerMethod(path : String, method : Method, process : RouteProcess<IRoute, {}>) {
    Reflect.callMethod(
      expressRouter,
      Reflect.field(expressRouter, method), [
        path,
        process.run
      ]
    );
  }
#end
  macro public function register(_this : Expr, instance : Expr)
    return abe.core.macros.AutoRegisterRoute.register(_this, instance);
}
