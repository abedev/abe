package routes;

import utest.Assert;

class Manual implements restx.IRoute {
  public function noArgs() {
    response.send("Hello World");
  }

  public function withArgs(i : Int, b : Bool, s : String) {
    Assert.is(i, Int);
    Assert.is(b, Bool);
    Assert.is(s, String);
    response.send({ i : i, b : b, s : s });
  }

  public function withOptionalArg(?i : Int, b : Bool) {
    if(null != i)
      Assert.is(i, Int);
    Assert.is(b, Bool);
    response.send({ i : i, b : b });
  }
}