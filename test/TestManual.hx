import abe.core.DynamicRouteProcess;
import utest.Assert;
import routes.*;
import abe.core.Source;
import abe.core.ArgumentProcessor;

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

    get("/manual/withargs/7/false/text", function(msg) {
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

    get("/manual/optionalarg/true/?i=9", function(msg) {
      Assert.equals('{"i":9,"b":true}', msg);
    });

    get("/manual/optionalarg/true/", function(msg) {
      Assert.equals('{"i":null,"b":true}', msg);
    });
  }
}
