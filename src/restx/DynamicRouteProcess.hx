package restx;

import express.Next;
import express.Request;
import express.Response;
import haxe.Constraints.Function;
import restx.core.ArgumentProcessing;
import restx.core.ArgumentProcessor;
import restx.core.ArgumentRequirement;
import restx.core.ArgumentsFilter;

class DynamicRouteProcess extends RouteProcess<IRoute, {}> {
  var method : Function;
  public function new(instance : IRoute, method : Function, argumentProcessor : ArgumentProcessor<{}>) {
    super(instance, argumentProcessor);
    this.method = method;
  }

  override function execute() {
    var list = Reflect.fields(arguments);
    Reflect.callMethod(null, method, list.map(function(arg) {
      return Reflect.field(arguments, arg);
    }));
  }
}