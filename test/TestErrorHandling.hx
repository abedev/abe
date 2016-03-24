import utest.Assert;

import abe.error.*;
import express.*;
using thx.Strings;

class TestErrorHandling extends TestCalls {
  public function testBasicHttpError() {
    var normalRouter = app.router.mount("/"),
        debugRouter = app.router.mount("/debug");

    normalRouter.register(new ErrorMaker());
    debugRouter.register(new ErrorMaker());
    normalRouter.error(abe.mw.ErrorHandler.handle());
    debugRouter.error(abe.mw.ErrorHandler.handle(true));

    get("/badrequest", function (err, res) {
      Assert.equals("Bad Request", extractMessage(err));
      Assert.equals(400, res.statusCode);
    });

    get("/unauthorized", function (err, res) {
      Assert.equals("Must be logged in", extractMessage(err));
      Assert.equals(401, res.statusCode);
    });

    get("/forbidden", function (err, res) {
      Assert.equals("Forbidden", extractMessage(err));
      Assert.equals(403, res.statusCode);
    });

    get("/notfound", function (err, res) {
      Assert.isTrue(extractMessage(err).startsWith("Resource"));
      Assert.equals(404, res.statusCode);
    });

    get("/teapot/coffee", function (_, res) {
      Assert.equals(418, res.statusCode);
    });

    get("/internalserver", function (err, res) {
      Assert.equals("Internal Server Error", extractMessage(err));
      Assert.equals(500, res.statusCode);
    });

    get("/notimplemented", function (err, res) {
      Assert.equals("Not Implemented", extractMessage(err));
      Assert.equals(501, res.statusCode);
    });

    get("/badgateway", function (err, res) {
      Assert.equals("Bad Gateway", extractMessage(err));
      Assert.equals(502, res.statusCode);
    });

    get("/serviceunavailable", function (err, res) {
      Assert.equals("Service Unavailable", extractMessage(err));
      Assert.equals(503, res.statusCode);
    });

    get("/gatewaytimeout", function (err, res) {
      Assert.equals("Gateway Timeout", extractMessage(err));
      Assert.equals(504, res.statusCode);
    });

    get("/uncaught", function (err, res) {
      Assert.equals("Something went wrong", extractMessage(err));
      Assert.equals(500, res.statusCode);
    });

    get("/completely/missing", function (_, res) {
      Assert.equals(404, res.statusCode);
    });

    // in debug mode, the request returns an object instead of a string
    get("/debug/badRequest", function (body, res) {
      var parsed = haxe.Json.parse(body);
      Assert.equals("Bad Request", parsed.message);
      Assert.isTrue(parsed.stackItems.length > 0);
      Assert.equals(400, res.statusCode);
    });
  }

  static function extractMessage(err : String) : String
    return haxe.Json.parse(err).message;
}

class ErrorMaker implements abe.IRoute {
  @:get("/badrequest")
  function badRequest() {
    next.error(new BadRequestError());
  }

  @:get("/unauthorized")
  function unauthorized() {
    next.error(new UnauthorizedError("Must be logged in"));
  }

  @:get("/forbidden")
  function forbidden() {
    next.error(new ForbiddenError());
  }

  @:get("/notfound")
  function notFound() {
    next.error(new NotFoundError("Resource Not Found"));
  }

  @:get("/teapot/coffee")
  function teapot() {
    next.error(new BaseHttpError("I'm a teapot", 418));
  }

  @:get("/internalserver")
  function internalServerError() {
    next.error(new InternalServerError());
  }

  @:get("/notimplemented")
  function notImplemented() {
    next.error(new NotImplementedError());
  }

  @:get("/badgateway")
  function badGateway() {
    next.error(new BadGatewayError());
  }

  @:get("/gatewaytimeout")
  function gatewayTimeout() {
    next.error(new GatewayTimeoutError());
  }

  @:get("/serviceunavailable")
  function serviceUnavailable() {
    next.error(new ServiceUnavailableError());
  }

  @:get("/uncaught")
  function uncaughtError() {
    next.error(new thx.Error("Something went wrong"));
  }
}
