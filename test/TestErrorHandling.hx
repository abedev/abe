import utest.Assert;

import abe.error.*;
import express.*;

class TestErrorHandling extends TestCalls {
  public function testBasicHttpError() {
    app.router.register(new ErrorMaker());
    app.router.error(abe.mw.ErrorHandler.handle);

    get("/teapot/coffee", function (_, res) {
      Assert.equals(418, res.statusCode);
    });
  }
}

class ErrorMaker implements abe.IRoute {
  @:get("/teapot/coffee")
  function unauthorized() {
    next.error(new BaseHttpError("I'm a teapot", 418));
  }
}
