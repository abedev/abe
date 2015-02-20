import restx.core.DynamicRouteProcess;
import utest.Assert;
import routes.*;
import restx.core.Source;
import restx.core.ArgumentProcessor;

class TestManual extends TestCalls {
  public function testManual() {
    var path = "/manual/noarg",
        instance = new Manual();

    router.registerMethod(path, Get,
      new DynamicRouteProcess(instance, instance.noArgs, new ArgumentProcessor([])));

    request(path, Get, function(msg) {
      Assert.equals("Hello World", msg);
    });
  }

  public function testManualWithArguments() {
    var instance = new Manual();

    router.registerMethod("/manual/withargs/:i/:b/:s", Get,
      new DynamicRouteProcess(instance, instance.withArgs, new ArgumentProcessor([
              { name : "i", type : "Int", optional : false, sources : [Params] },
              { name : "b", type : "Bool", optional : false, sources : [Params] },
              { name : "s", type : "String", optional : false, sources : [Params] }
            ])));

    request("/manual/withargs/7/false/text", Get, function(msg) {
      Assert.equals('{"i":7,"b":false,"s":"text"}', msg);
    });
  }

  public function testManualWithOptionalArgument() {
    var instance = new Manual();

    router.registerMethod("/manual/optionalarg/:b/", Get,
      new DynamicRouteProcess(instance, instance.withOptionalArg, new ArgumentProcessor([
              { name : "i", type : "Int", optional : true, sources : [Query] },
              { name : "b", type : "Bool", optional : false, sources : [Params] }
            ])));

    request("/manual/optionalarg/true/?i=9", Get, function(msg) {
      Assert.equals('{"i":9,"b":true}', msg);
    });

    request("/manual/optionalarg/true/", Get, function(msg) {
      Assert.equals('{"i":null,"b":true}', msg);
    });
  }
}