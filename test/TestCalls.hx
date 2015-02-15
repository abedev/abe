import restx.DynamicRouteProcess;
import utest.Assert;
import routes.*;
import restx.Router;
import restx.core.Source;
import restx.core.ArgumentProcessor;
import js.node.Http;
import js.node.http.Method;
import js.node.http.IncomingMessage;

class TestCalls {
  var port : Int;
  var router : Router;
  public function new(port : Int, router : Router) {
    this.port = port;
    this.router = router;
  }

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

  public function testAuto() {
    router.register(new Auto());
  }

  function request(path : String, method : String, callback : String -> Void) {
    var done = Assert.createAsync(2000);
    Http.request({
        host : "localhost",
        port : port,
        method : method,
        path : path
      }, function(msg : IncomingMessage) {
        var data = "";
        msg.on("data", function(chunk) {
          data += chunk;
        });
        msg.on("end", function() {
          callback(data);
          done();
        });
      }).end();
  }
}