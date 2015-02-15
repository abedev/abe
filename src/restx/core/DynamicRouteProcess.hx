package restx.core;

import haxe.Constraints.Function;
import restx.core.ArgumentProcessor;

class DynamicRouteProcess extends RouteProcess<IRoute, {}> {
  var method : Function;
  public function new(instance : IRoute, method : Function, argumentProcessor : ArgumentProcessor<{}>) {
    super(instance, argumentProcessor);
    this.method = method;
    this.arguments = {};
  }

  override function execute() {
    var list = Reflect.fields(arguments);
    Reflect.callMethod(null, method, list.map(function(arg) {
      return Reflect.field(arguments, arg);
    }));
  }
}