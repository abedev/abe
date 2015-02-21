package express;

extern class Request extends js.node.http.IncomingMessage {
  var app : Express;
  var baseUrl : String;
  var body : {};

  //var cookies : {}; // TODO requires middleware

  var fresh : Bool;
  var hostname : String;
  var ip : String;
  var ips : Array<String>;
  var originUrl : String;
  var params : {};
  var path : String;
  var protocol : String; // TODO needs abstract
  var query : {};
  var route : String;
  var secure : Bool;

  //var signedCookies : {}; // TODO requires middleware

  var stale : Bool;
  var subdomains : Array<String>;
  var xhr : Bool;

  @:overload(function(types : Array<String>) : String {})
  function accepts(type : String) : String;

  function acceptsCharsets(charset : String, charsets : haxe.Rest<String>) : String;
  function acceptsEncodings(encoding : String, encodings : haxe.Rest<String>) : String;
  function acceptsLanguages(languageg : String, languages : haxe.Rest<String>) : String;

  function get(field : String) : String;
  function is(type : String) : Bool;
  function param(name : String, ?defaultValue : String) : String;
}