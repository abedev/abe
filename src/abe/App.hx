package abe;

import express.Middleware;
import js.node.Http;
import js.node.Https;
import js.node.Tls.TlsServerOptions;
import express.Express;
using thx.core.Nulls;

class App {
  public var router(default, null) : Router;
  public var express(default, null) : Express;

  public function new(?options : Options) {
    options = options.or({});
    express = new Express();

    if(options.strictRoute)
      express.set("strict route", true);
    if(options.caseSensitiveRouting)
      express.set("case sensitive routing", true);

    express.set("x-powered-by", false);

    var r  = new express.Router();
    express.use("/", r);
    router = new Router(r);
  }

  public function sub(path : String) {
    var sub = new App();
    express.use(path, sub.express);
    return sub;
  }

  public function http(port : Int, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = Http.createServer(cast express);
    server.listen(port, host, backlog, callback);
    return server;
  }

  public function https(port : Int, options : TlsServerOptions, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = Https.createServer(options, cast express);
    server.listen(port, host, backlog, callback);
    return server;
  }
}

typedef Options = {
  ?strictRoute : Bool,
  ?caseSensitiveRouting : Bool
}
