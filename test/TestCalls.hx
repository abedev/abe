import restx.core.DynamicRouteProcess;
import utest.Assert;
import routes.*;
import restx.App;
import restx.Router;
import restx.core.Source;
import restx.core.ArgumentProcessor;
import js.node.Http;
import js.node.http.*;
import js.node.http.Method;
import js.node.Querystring;

class TestCalls {
  static var port = 8888;
  public function new() {}

  var app : App;
  var router : Router;
  var server : js.node.http.Server;
  public function setup() {
    app = new App();
    router = app.router;
    server = app.http(port);
  }

  public function teardown() {
    server.close();
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

    request("/auto/", Get, function(msg) {
      Assert.equals('DONE', msg);
    });

    request("/auto/", Post, {foo: 'bar'}, function(msg : String) {
      Assert.equals('POSTED', msg);
    });
  }

  public function testMount() {
    var sub = router.mount("/sub/");
    sub.register(new Auto());

    request("/sub/auto/", Get, function(msg) {
      Assert.equals('DONE', msg);
    });
  }

  function request(path : String, method : Method, ?payload : {}, callback : String -> Void) {
    var done = Assert.createAsync(2000);
    var r = Http.request({
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
      });

    if (null != payload) {
      var b = Querystring.stringify(payload);
      r.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      r.setHeader('Content-Length', '${b.length}');
      r.write(b);
    }
    r.end();
  }
}