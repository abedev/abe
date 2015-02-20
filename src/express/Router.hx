package express;

@:jsRequire("express", "Router")
extern class Router {
  @:selfCall function new(?options : RouterOptions) : Void;

  // TODO: complete
  @:overload(function(subApp : Express) : Express {})
  function use(?path : String, middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware, ?middleware : Middleware) : Express;

  function listen(port : Int, ?hostname : String, ?backlog : Int, ?callback : Void -> Void) : Void;
}

typedef RouterOptions = {
  ?caseSensitive : Bool,
  ?mergeParams : Bool,
  ?strict : Bool
}
