package express;

import js.Error;

extern class Response extends js.node.http.ServerResponse {
  var app : Express;
  var headersSend : Bool;
  var locals : {};

  @:overload(function(field : String, values : Array<String>) : Void {})
  function append(field : String, value : String) : Void;
  function attachment(?filename : String) : Void;
  function cookie(name : String, value : String, ?options : CookieOptions) : Void;
  function clearCookie(name : String, ?options : CookieOptions) : Void;
  function download(path : String, ?filename : String, ?callback : Error -> Void) : Void;
  function format(object : Dynamic<Void -> Void>) : Void;
  function get(field : String) : String;
  @:overload(function(body : Int) : Void {})
  @:overload(function(body : Float) : Void {})
  @:overload(function(body : String) : Void {})
  @:overload(function(body : Array<Dynamic>) : Void {})
  function json(body : {}) : Void;
  @:overload(function(body : Int) : Void {})
  @:overload(function(body : Float) : Void {})
  @:overload(function(body : String) : Void {})
  @:overload(function(body : Array<Dynamic>) : Void {})
  function jsonp(body : {}) : Void;
  function links(links : Dynamic<String>) : Void;
  function location(path : String) : Void;
  function redirect(?status : Int, path : String) : Void;
  function render(view : String, ?locals : {}, ?callback : Error -> String -> Void) : Void;
  @:overload(function(body : js.node.Buffer) : Void {})
  @:overload(function(body : String) : Void {})
  @:overload(function(body : Array<Dynamic>) : Void {})
  function send(body : {}) : Void;
}

typedef CookieOptions = {
  ?domain : String,
  ?expires : Date,
  ?httpOnly : Bool,
  ?maxAge : String,
  ?path : String,
  ?secure : Bool,
  ?signed : Bool,
}