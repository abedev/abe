package abe.core;

import haxe.Constraints.Function;
import abe.core.ArgumentProcessor;

class DynamicRouteProcess extends RouteProcess<IRoute, {}> {
  var method : Function;
  public function new(instance : IRoute, method : Function, argumentProcessor : ArgumentProcessor<{}>) {
    super({}, instance, argumentProcessor);
    this.method = method;
  }

  override function execute() {
    var list = Reflect.fields(args);
    Reflect.callMethod(null, method, list.map(function(arg) {
      return Reflect.field(args, arg);
    }));
  }
}