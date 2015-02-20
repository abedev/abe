package restx;

import express.Express;

class App {
  public var port(default, null) : Int;
  public var router(default, null) : Router;

  var server : Express;
  public function new(port : Int) {
    this.port = port;
    this.server = new Express({});
    this.router = new Router(server);
  }

  public function start(?callback : Void -> Void) {
    server.listen(port, function() {
      trace('listening on ${port}');
      if(null != callback)
        callback();
    });
  }
}