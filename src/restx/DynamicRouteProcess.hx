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

class DynamicRouteProcess<T : Function> extends RouteProcess {
  var instance : IRoute;
  var method : Function;
  var requirements : Array<ArgumentRequirement>;
  var argumentProcessor : ArgumentProcessor;
  public function new(instance : IRoute, method : T, argumentProcessor : ArgumentProcessor) {
    super();
    this.instance = instance;
    this.method = method;
    this.requirements = null != requirements ? requirements : [];
    this.argumentProcessor = argumentProcessor;
  }

  override public function run(req : Request, res : Response, next : Next) {
    switch processArguments(req) {
      case Ok(args):
        instance.request = req;
        instance.response = res;
        instance.next = next;
        Reflect.callMethod(null, method, args);
      case Required(msg), InvalidType(msg):
        // TODO add proper status code
        (next : Error -> Void)(new Error(msg));
    }
  }

  function processArguments(req : Request) : ArgumentProcessing
    return argumentProcessor.processArguments(req);
}