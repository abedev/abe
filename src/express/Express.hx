package express;

@:jsRequire("express")
extern class Express {
  @:selfCall function new(?options : Dynamic) : Void;

  var locals(default, null) : Dynamic;
  var mountpath(default, null) : Array<String>;

  // TODO: complete
  @:overload(function(subApp : Express) : Express {})
  function use(?path : String, middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware) : Express;
}