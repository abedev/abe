import utest.Assert;
import routes.*;

class TestParam extends TestCalls {
  public function testFromQS() {
    router.register(new Param());

    get("/list/", function(msg, _) {
      Assert.equals('page: 1', msg);
    });

    get("/list/?page=2", function(msg, _) {
      Assert.equals('page: 2', msg);
    });

    get("/list2/some/?page=2", function(msg, _) {
      Assert.equals('some: 2', msg);
    });

    // restrict param source
    get("/get/123?partial=true&id=456", function(msg, res) {
      if(res.statusCode != 200) {
        Assert.fail(msg);
      } else {
        Assert.same({ partial : true, id : 123 }, haxe.Json.parse(msg));
      }
    });

    post("/post/?a=A&b=B&c=C", {a:"a",b:"b",c:"c"}, function(msg : String, res) {
      if(res.statusCode != 200) {
        Assert.fail(msg);
      } else {
        Assert.same({
          a : "A",
          b : "B",
          c : "c"
        }, haxe.Json.parse(msg));
      }
    });
  }
}

class Param implements abe.IRoute {
  @:get("/list/")
  @:args(query)
  function fromQS(page : Int = 1) {
    response.send('page: $page');
  }

  @:get("/list2/:name")
  @:args(query, params)
  function fromQSAndParam(name : String, page : Int = 1) {
    response.send('$name: $page');
  }

  @:post("/list2/")
  @:args(body)
  function fromBodyArray(name : String, pages : Array<String>) {
    response.send('$name: $pages');
  }

  @:get("/get/:id")
  @:args(query(partial), params(id))
  function restrict(id : Int, partial : Bool) {
    response.send({
      id : id,
      partial : partial
    });
  }

  @:post("/post/")
  @:use(mw.BodyParser.urlencoded({ extended : false }))
  @:args(query(a,b), body(c))
  function restrictQuery(a : String, b : String, c : String) {
    response.send({ a : a, b : b, c : c });
  }
}
