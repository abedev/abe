package restx;

#if macro
import haxe.macro.Expr;
#else
import haxe.Constraints.Function;
import js.node.http.Method;
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
  macro public function register(_this : Expr, instance : Expr) {
    // get the type

    // iterate on all the fields and filter the functions that have @:path

    // for each iterate on all the HTTP methods (at least Get)

    // create a class type for each controller function

    // create processor instance

    // pass additional filters

    // registerMethod(path, method, router)
    return macro (function(instance) {

    })($instance);
  }
}