import utest.ui.Report;
import utest.Runner;

class TestAll {
  public static function main() {
    abe.App.installNpmDependencies();

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
    runner.addCase(new TestValidate());
    runner.addCase(new TestIs());
    runner.addCase(new TestError());
    runner.addCase(new TestErrorHandling());

    // report
    Report.create(runner);
    runner.run();
  }

  public function new() {}
}
