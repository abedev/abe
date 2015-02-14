package restx;

import haxe.Constraints.Function;
using thx.core.Nulls;

class Router {
  var server : Dynamic;
  public function new(server : Dynamic) {
    this.server = server;
  }

  public function register(info : RouteInfo) {
    var method = info.method.or("GET").toLowerCase();
    Reflect.callMethod(
      server,
      Reflect.field(server, method), [
        info.path,
        function(req, res, next) {
          info.instance.request = req;
          info.instance.response = res;
          info.controller();
          next();
        }
      ]
    );
  }
}

typedef RouteInfo = {
  path : String,
  method : String,
  instance : IRoute,
  controller : Function
}