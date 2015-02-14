package restx;

import haxe.Constraints.Function;
import js.node.http.Method;
using thx.core.Nulls;

class Router {
  var server : Dynamic;
  public function new(server : Dynamic) {
    this.server = server;
  }

  public function register(path : String, method : Method, process : RouteProcess) {
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
}