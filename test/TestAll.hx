import js.node.http.Method;
import utest.Assert;
import utest.ui.Report;
import utest.Runner;

import restx.*;

class TestAll {
  static var port = 8888;
  public static function main() {
    // run server
    runServer(function() {
      var runner = new Runner();
      // run static tests
      runner.addCase(new TestAll());

      // run REST tests
      runner.addCase(new TestCalls(port));

      // report
      Report.create(runner);
      runner.run();
    });

  }

  static function runServer(callback : Void -> Void) {
    var app = new App(port),
        instance = new routes.Index();

    // manual registration
    app.router.register("/", Get, new restx.DynamicRouteProcess(instance, instance.manual));

    // start server
    app.start(callback);
  }

  public function new() {}

}
