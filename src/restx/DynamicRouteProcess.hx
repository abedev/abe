package restx;

import express.Next;
import express.Request;
import express.Response;
import haxe.Constraints.Function;
import restx.core.ArgumentProcessing;
import restx.core.ArgumentProcessor;
import restx.core.ArgumentRequirement;
import restx.core.ArgumentsFilter;
import js.Error;

class DynamicRouteProcess extends RouteProcess<IRoute> {
  var instance : IRoute;
  var method : Function;
  var argumentProcessor : ArgumentProcessor;
  public function new(instance : IRoute, method : Function, argumentProcessor : ArgumentProcessor) {
    super();
    this.instance = instance;
    this.argumentProcessor = argumentProcessor;
    this.method = method;
  }

  override public function run(req : Request, res : Response, next : Next) {
    switch argumentProcessor.processArguments(req) {
      case Ok(args):
        instance.request = req;
        instance.response = res;
        instance.next = next;
        var list = Reflect.fields(args);
        Reflect.callMethod(null, method, list.map(function(arg) {
          return Reflect.field(args, arg);
        }));
      case Required(msg), InvalidType(msg):
        // TODO add proper status code
        (next : Error -> Void)(new Error(msg));
    }
  }
}