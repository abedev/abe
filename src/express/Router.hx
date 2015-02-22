package express;

@:jsRequire("express", "Router")
extern class Router extends Routes {
  @:selfCall function new(?options : RouterOptions) : Void;
  function param(?name : String, callback : Request -> Response -> Next -> String -> Void) : Void;
  function path() : String;
  @:overload(function(?path : String, router : Router) : Router {})
  function use(?path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Router;
}

typedef RouterOptions = {
  ?caseSensitive : Bool,
  ?mergeParams : Bool,
  ?strict : Bool
}
