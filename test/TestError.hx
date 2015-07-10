import utest.Assert;

import express.*;

class TestError extends TestCalls {
  public function testUse() {
    app.router.register(new ErrorPath());
    app.router.use(function(req : Request, res : Response, next : Next) {
      var err = new express.Error("not found");
      err.status = 777;
      next.error(err);
    });
    app.router.error(function(err : express.Error, req, res, next) {
      Assert.equals(777, err.status);
      err.status = 666;
      next(err);
    });
    app.error(function(err, req, res, next) {
      Assert.equals(666, err.status);
      res.sendStatus(555);
    });

    get("/error/badrequest", function(_, res) {
      Assert.equals(555, res.statusCode);
    });

    get("/error/", function(_, res) {
      Assert.equals(555, res.statusCode);
    });
  }
}

class ErrorPath implements abe.IRoute {
  @:get("/error/")
  function index() {
    var err = new express.Error("no way");
    err.status = 777;
    next.error(err);
  }
}
