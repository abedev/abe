package restx;

import js.node.Http;
import js.node.Https;
import js.node.Tls.TlsServerOptions;
import express.Express;

class App {
  public var router(default, null) : Router;

  var server : Express;
  public function new() {
    this.server = new Express({});
    this.router = new Router(server);
  }

  public function http(port : Int, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = Http.createServer(cast server);
    server.listen(port, host, backlog, function() {
        trace('HTTP listening on ${port}');
        if(null != callback)
          callback();
      });
    return server;
  }

  public function https(port : Int, options : TlsServerOptions, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = Https.createServer(options, cast server);
    server.listen(port, host, backlog, function() {
        trace('HTTPS listening on ${port}');
        if(null != callback)
          callback();
      });
    return server;
  }
}