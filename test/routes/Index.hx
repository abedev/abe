package routes;

import restx.IRoute;

class Index implements IRoute {
  public var request : Dynamic;
  public var response : Dynamic;
  public function new() {}

  public function manual() {
    response.send("Hello World");
  }
}