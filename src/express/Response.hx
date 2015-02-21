package express;

// TODO is extending js.node.http.ServerResponse right?
extern class Response extends js.node.http.ServerResponse implements Dynamic {
  var app : Express;
  var headersSend : Bool;
  var locals : {};

  @:overload(function(field : String, values : Array<String>) : Void {})
  function append(field : String, value : String) : Void;

  function attachment(?filename : String) : Void;

  function cookie(name : String, value : String, ?options : CookieOptions) : Void;
  function clearCookie(name : String, ?options : CookieOptions) : Void;
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