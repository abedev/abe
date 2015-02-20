import utest.Assert;
import utest.ui.Report;
import utest.Runner;

import restx.*;

class TestAll {
  static var port = 8888;
  public static function main() {
    var runner = new Runner();
    // run static tests
    runner.addCase(new TestAll());

    // run REST tests
    runner.addCase(new TestCalls());

    // report
    Report.create(runner);
    runner.run();
  }

  public function new() {}
}
