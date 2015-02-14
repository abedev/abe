import utest.Assert;
import utest.ui.Report;
import utest.Runner;

import restx.*;

class TestAll {
  static var port = 8888;
  public static function main() {
    // run server
    runServer();

    // run static tests
    var runner = new Runner();
    runner.addCase(new TestAll());
    runner.addCase(new TestCalls());
/*    runner.onComplete.add(function(runner) {
      trace("DONE!");
      trace(runner);
      js.Node.process.exit();
    });
   */
    Report.create(runner);
    runner.run();
  }

  static function runServer() {
    var app = new App(port);
    app.router.register("/", new routes.Index().main);
    app.start();
  }

  public function new() {}

}
