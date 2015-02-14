import utest.Assert;
import utest.ui.Report;
import utest.Runner;

class TestAll {
  public static function main() {
    var runner = new Runner();
    runner.addCase(new TestAll());
    Report.create(runner);
    runner.run();
  }

  public function new() {}
}
