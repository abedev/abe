import utest.Assert;
import routes.*;
import thx.Either;
import thx.OrderedMap;
import thx.OrderedSet;
import thx.Set;
import thx.promise.Promise;
import thx.promise.Future;
using thx.Strings;
using thx.Result;

class TestTypedRoutes extends TestCalls {
  public function testPath() {
    var typed = router.mount("/typed");
    typed.register(new TypedRoutes());
    typed.error(abe.mw.ErrorHandler.handle(TextError));

    get("/typed/test/text/", function(msg, _) {
      Assert.equals('MY TEXT', msg);
    });

    get("/typed/test/noContent/", function(_, res) {
      Assert.equals(204, res.statusCode);
    });

    get("/typed/test/statusCode/", function(_, res) {
      Assert.equals(555, res.statusCode);
    });

    get("/typed/test/right/", function(_, res) {
      Assert.equals(333, res.statusCode);
    });

    get("/typed/test/left/", function(msg, _) {
      Assert.equals("OK", msg);
    });

    get("/typed/test/promise/success", function(msg, _) {
      Assert.equals("OK", msg);
    });

    get("/typed/test/promise/failure", function(msg, res) {
      Assert.equals(500, res.statusCode);
      Assert.equals("OH MAN", msg);
    });

    get("/typed/test/future", function(msg, _) {
      Assert.equals("OK", msg);
    });

    get("/typed/test/file", function(msg, _) {
      Assert.isTrue(msg.contains("<svg"));
    });

    get("/typed/test/redirect", function(msg, res) {
      Assert.equals(302, res.statusCode);
      Assert.isTrue(msg.contains("Redirecting to"));
    });

    get("/typed/test/badrequest", function(msg, res) {
      Assert.equals(400, res.statusCode);
    });

    get("/typed/test/error", function(msg, res) {
      Assert.equals(500, res.statusCode);
      Assert.equals("OH BOY", msg);
    });

    get("/typed/test/anonymous", function(o, _) {
      Assert.equals("ALL GOOD", haxe.Json.parse(o).message);
    });

    get("/typed/test/array/readonly", function(o, _) {
      Assert.same([1,2,3,4], haxe.Json.parse(o));
    });

    get("/typed/test/array", function(o, _) {
      Assert.same([1,2,3,4], haxe.Json.parse(o));
    });

    get("/typed/test/result/success", function(msg, _) {
      Assert.equals("OK", msg);
    });

    get("/typed/test/result/failure", function(msg, res) {
      Assert.equals(500, res.statusCode);
      Assert.equals("OH MAN", msg);
    });

    get("/typed/test/tojson/cls/string", function(o, _) {
      Assert.equals("value", haxe.Json.parse(o).message);
    });

    get("/typed/test/tojson/cls/object", function(o, _) {
      Assert.equals("value", haxe.Json.parse(o).message);
    });

    get("/typed/test/tojson/cls/dynamic", function(o, _) {
      Assert.equals("value", haxe.Json.parse(o).message);
    });

    get("/typed/test/tojson/anon/string", function(o, _) {
      Assert.equals("value", haxe.Json.parse(o).message);
    });

    get("/typed/test/tojson/anon/object", function(o, _) {
      Assert.equals("value", haxe.Json.parse(o).message);
    });

    get("/typed/test/map", function(o, _) {
      Assert.same({ a : 1, b : 2}, haxe.Json.parse(o));
    });

    get("/typed/test/orderedMap", function(o, _) {
      Assert.same({ a : 1, b : 2}, haxe.Json.parse(o));
    });

    get("/typed/test/buffer", function(msg, _) {
      Assert.equals("BYTES", msg);
    });
  }
}

@:path("/test")
class TypedRoutes implements abe.IRoute {
  @:get("/text")
  function text() return 'MY TEXT';

  @:get("/noContent")
  function noContent() return thx.Nil.nil;

  @:get("/statusCode")
  function statusCode() return 555;

  @:get("/right")
  function right() : Either<String, Int> return Either.Right(333);

  @:get("/left")
  function left() : Either<String, Int> return Either.Left("OK");

  @:get("/promise/success")
  function promiseSuccess() return Promise.value("OK");

  @:get("/promise/failure")
  function promiseFailure() : Promise<String>
    return Promise.error(thx.Error.fromDynamic("OH MAN"));

  @:get("/future")
  function future() return Future.value("OK");

  @:get("/file")
  function file() return (js.Node.__dirname : thx.Path) / "../assets/abe-logo.svg";

  @:get("/redirect")
  function redirect() return ('http://localhost:${TestCalls.port}/typed/test/text/' : thx.Url);

  @:get("/badrequest")
  function badRequest() return new abe.error.BadRequestError();

  @:get("/error")
  function error() return new thx.Error("OH BOY");

  @:get("/anonymous")
  function anonymous() return { message : "ALL GOOD" };

  @:get("/array")
  function array() return [1,2,3,4];

  @:get("/array/readonly")
  function arrayReadonly() return ([1,2,3,4] : thx.ReadonlyArray<Int>);

  @:get("/result/success")
  function resultSuccess() : Result<String, thx.Error>
    return Result.success("OK");

  @:get("/result/failure")
  function resultFailure() : Result<String, thx.Error>
    return Result.failure(thx.Error.fromDynamic("OH MAN"));

  @:get("/tojson/cls/string")
  function toJsonClsString() return new WithToJsonString();

  @:get("/tojson/cls/object")
  function toJsonClsObject() return new WithToJsonObject();

  @:get("/tojson/cls/dynamic")
  function toJsonClsDynamic() return new WithToJsonDynamic();

  @:get("/tojson/anon/string")
  function toJsonAnonString() return {
    toJson : function() {
      return '{"message":"value"}';
    }
  };

  @:get("/tojson/anon/object")
  function toJsonAnonObject() return {
    toJson : function() {
      return {"message":"value"};
    }
  };

  @:get("/map")
  function map() return ["a" => 1, "b" => 2];

  @:get("/orderedMap")
  function orderedMap() {
    var map = OrderedMap.createString();
    map.set("a", 1);
    map.set("b", 2);
    return map;
  }

  @:get("/set")
  function set() {
    var set = Set.createInt();
    set.add(1);
    set.add(1);
    set.add(2);
    return set;
  };

  @:get("/orderedSet")
  function orderedSet() {
    return OrderedSet.create([1,1,2]);
  }

  @:get("/buffer")
  function buffer() {
    return new js.node.Buffer("BYTES");
  }
}

class WithToJsonString {
  public function new() {}
  public function toJson() : String
    return '{"message":"value"}';
}

class WithToJsonObject {
  public function new() {}
  public function tojson() : {}
    return {message:"value"};
}

class WithToJsonDynamic {
  public function new() {}
  public function toJSON() : Dynamic
    return {message:"value"};
}
