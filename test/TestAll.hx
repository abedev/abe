import utest.ui.Report;
import utest.Runner;

class TestAll {
  public static function main() {
    abe.App.installNpmDependencies();

    abe.Ports.ifAvailable(TestCalls.port)
      .success(function(_) runTests())
      .failure(function(e) js.Node.console.error('unable to run tests: ${e.message}'));
  }

  public static function runTests() {
    var runner = new Runner();

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
    runner.addCase(new TestTypedRoutes());

    // report
    Report.create(runner);
    runner.run();
  }

  public function new() {}
}
