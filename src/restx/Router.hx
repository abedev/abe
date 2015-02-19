package restx;
import restx.Method;

#if macro
import haxe.macro.Expr;
#else
import haxe.Constraints.Function;
#end

class Router {
  var server : Dynamic;
  public function new(server : Dynamic) {
    this.server = server;
  }
#if !macro
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