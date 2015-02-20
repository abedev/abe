package routes;

import utest.Assert;

class Auto implements restx.IRoute {
  @:get("/auto/")
  function noParams() {
    response.send("DONE");
  }

  @:post("/auto/")
  function noParamPost() {
    response.send("POSTED");
  }

  @:get("/auto/:name/:age")
  function withParams(name : String, age : Int) {
    Assert.is(name, String);
    Assert.is(age, Int);
    response.send({name:name,age:age});
  }
}