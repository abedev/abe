package restx;

import restify.Restify;

class App {
  public var port(default, null) : Int;
  public var router(default, null) : Router;

  var server : Dynamic;
  public function new(port : Int) {
    this.port = port;
    this.server = Restify.createServer({
      name : "RESTX"
    });
    this.router = new Router(server);
  }

  public function start(?callback : Void -> Void) {
    server.listen(port, function() {
      trace('${server.name} listening on ${server.url}');
      if(null != callback)
        callback();
    });
  }
}