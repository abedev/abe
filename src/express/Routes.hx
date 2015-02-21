package express;

extern class Routes {
  function all(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function checkout(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function connect(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function copy(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function delete(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function get(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function head(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function lock(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function merge(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function mkactivity(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function mkcol(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function move(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function notify(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function options(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function patch(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function post(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function propfind(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function proppatch(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function purge(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function put(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function report(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function subscribe(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function trace(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function unlock(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
  function unsubscribe(path : String, callback : Middleware, callbacks : haxe.Rest<Middleware>) : Void;
}