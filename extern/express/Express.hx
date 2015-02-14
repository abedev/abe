package express;

import haxe.Constraints.Function;

@:jsRequire("express")
extern class Express {
  @:selfCall function new(?options : Dynamic) : Void;

  var locals(default, null) : Dynamic;
  var mountpath(default, null) : Array<String>;

  // TODO: complete
  @:overload(function(subApp : Express) : Express {})
  function use(?path : String, middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware) : Express;
}

typedef FMiddlware = Response -> Request -> Void;
typedef FMiddlwareNext = Response -> Request -> (Void -> Void) -> Void;
typedef FMiddlwareNextRoute = Response -> Request -> (String -> Void) -> Void;

abstract Middleware(Dynamic)
  from FMiddlware to FMiddlware
  from FMiddlwareNext to FMiddlwareNext
  from FMiddlwareNextRoute to FMiddlwareNextRoute
{

}