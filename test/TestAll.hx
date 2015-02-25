import utest.ui.Report;
import utest.Runner;

class TestAll {
  static var port = 8888;
  public static function main() {
    var runner = new Runner();
    // run static tests
    runner.addCase(new TestAll());

    // run REST tests
    runner.addCase(new TestManual());
    runner.addCase(new TestAuto());
    runner.addCase(new TestParam());
    runner.addCase(new TestPath());
    runner.addCase(new TestUse());
    runner.addCase(new TestStatic());

    // report
    Report.create(runner);
    runner.run();
  }

  public function new() {}
}
