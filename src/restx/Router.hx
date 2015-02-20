package restx;
import restx.Method;

#if macro
import haxe.macro.Expr;
#else
import express.Express;
import haxe.Constraints.Function;
#end

class Router {
#if !macro
  var server : Express;
  public function new(server : Express) {
    this.server = server;
  }
  public function registerMethod(path : String, method : Method, process : RouteProcess<IRoute, {}>) {
    if(null == method)
      method = Get;

    Reflect.callMethod(
      server,
      Reflect.field(server, (method : String).toLowerCase()), [
        path,
        process.run
      ]
    );
  }
#end
  macro public function register(_this : Expr, instance : Expr)
    return restx.core.macros.AutoRegisterRoute.register(_this, instance);
}