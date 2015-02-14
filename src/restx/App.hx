package restx;

class App {
  public var port(default, null) : Int;
  public var router(default, null) : Router;
  public function new(port : Int) {
    this.port = port;
    this.router = new Router();
    this.server = Restify.createServer({
      name : "RESTX"
    });
  }

  public function start() { }
}