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

    get("/badrequest", function (msg, res) {
      Assert.equals("Bad Request", msg);
      Assert.equals(400, res.statusCode);
    });

    get("/unauthorized", function (msg, res) {
      Assert.equals("Must be logged in", msg);
      Assert.equals(401, res.statusCode);
    });

    get("/forbidden", function (msg, res) {
      Assert.equals("Forbidden", msg);
      Assert.equals(403, res.statusCode);
    });

    get("/notfound", function (msg, res) {
      Assert.isTrue(msg.startsWith("Resource"));
      Assert.equals(404, res.statusCode);
    });

    get("/teapot/coffee", function (_, res) {
      Assert.equals(418, res.statusCode);
    });

    get("/internalserver", function (msg, res) {
      Assert.equals("Internal Server Error", msg);
      Assert.equals(500, res.statusCode);
    });

    get("/notimplemented", function (msg, res) {
      Assert.equals("Not Implemented", msg);
      Assert.equals(501, res.statusCode);
    });

    get("/badgateway", function (msg, res) {
      Assert.equals("Bad Gateway", msg);
      Assert.equals(502, res.statusCode);
    });

    get("/serviceunavailable", function (msg, res) {
      Assert.equals("Service Unavailable", msg);
      Assert.equals(503, res.statusCode);
    });

    get("/gatewaytimeout", function (msg, res) {
      Assert.equals("Gateway Timeout", msg);
      Assert.equals(504, res.statusCode);
    });

    get("/uncaught", function (msg, res) {
      Assert.equals("Something went wrong", msg);
      Assert.equals(500, res.statusCode);
    });

    get("/completely/missing", function (_, res) {
      Assert.equals(404, res.statusCode);
    });

    get("/debug/badRequest", function (body, res) {
      var parsed = haxe.Json.parse(body);
      Assert.equals("Bad Request", parsed.message);
      Assert.isTrue(parsed.stackItems.length > 0);
      Assert.equals(400, res.statusCode);
    });
  }
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
