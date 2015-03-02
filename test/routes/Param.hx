package routes;

import utest.Assert;

class Param implements abe.IRoute {
  @:get("/list/")
  @:args(query)
  function fromQS(page : Int = 1) {
    response.send('page: $page');
  }

  @:get("/list2/:name")
  @:args([query, params])
  function fromQSAndParam(name : String, page : Int = 1) {
    response.send('$name: $page');
  }

  @:post("/list2/")
  @:args(Body)
  function fromBodyArray(name : String, pages : Array<String>) {
    response.send('$name: $pages');
  }
}
