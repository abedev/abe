package express;

import js.Error;

@:jsRequire("express")
extern class Express extends Routes {
  @:selfCall function new() : Void;

  var locals(default, null) : {};
  var mountpath(default, null) : Array<String>;

  function on(event : ExpressEvent, callback : Express -> Void) : Void;

  function disable(name : String) : Void;
  function disabled(name : String) : Bool;
  function enable(name : String) : Void;
  function enabled(name : String) : Bool;
  function engine(ext : String, callback : String -> {} -> (Error -> String -> Void) -> Void) : Express;
  @:overload(function(name : String) : String {})
  override function get(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  // TODO return type is wrong
  function listen(port : Int, ?hostname : String, ?backlog : Int, ?callback : Void -> Void) : Void;
  function param(?name : String, callback : Request -> Response -> Next -> String -> Void) : Express;
  function path() : String;
  function render(view : String, ?locals : {}, callback : Error -> String -> Void) : Void;
  function route(path : String) : Routes;
  function search(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function set(name : String, value : Dynamic) : Express;
  @:overload(function(?path : String, app : Express) : Express {})
  @:overload(function(?path : String, router : Router) : Express {})
  function use(?path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Express;
}

@:enum
abstract ExpressEvent(String) from String to String {
  var mount = "mount";
}