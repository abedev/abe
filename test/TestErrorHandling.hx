import utest.Assert;

import abe.error.*;
import express.*;

class TestErrorHandling extends TestCalls {
  public function testBasicHttpError() {
    app.router.register(new ErrorMaker());
    app.router.error(abe.mw.ErrorHandler.handle);

    get("/unauthorized", function (msg, res) {
      Assert.equals("Must be logged in", msg);
      Assert.equals(401, res.statusCode);
    });

    get("/teapot/coffee", function (_, res) {
      Assert.equals(418, res.statusCode);
    });
  }
}

class ErrorMaker implements abe.IRoute {
  @:get("/unauthorized")
  function unauthorized() {
    next.error(new UnauthorizedError("Must be logged in"));
  }

  @:get("/teapot/coffee")
  function teapot() {
    next.error(new BaseHttpError("I'm a teapot", 418));
  }
}
