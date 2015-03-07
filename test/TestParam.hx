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
}
