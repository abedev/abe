package abe;

import express.Middleware;
import js.node.Http;
import js.node.Https;
import js.node.Tls.TlsServerOptions;
import express.Express;

class App {
  public var router(default, null) : Router;
  public var express(default, null) : Express;

  public function new() {
    express = new Express();
    var r  = new express.Router();
    express.use("/", r);
    router = new Router(r);
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
