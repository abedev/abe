package restx;

import express.Next;
import express.Request;
import express.Response;
import haxe.Constraints.Function;

class DynamicRouteProcess extends RouteProcess {
  var instance : IRoute;
  var method : Function;
  public function new(instance : IRoute, method : Function) {
    super();
    this.instance = instance;
    this.method = method;
  }
  override public function run(req : Request, res : Response, next : Next) {
    instance.request = req;
    instance.response = res;
    instance.next = next;
    method();
  }
}