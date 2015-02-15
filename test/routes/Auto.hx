package routes;

import utest.Assert;

class Auto implements restx.IRoute {
  @:path("/auto/")
  function noParams() {
    response.send("DONE");
  }

  @:path("/auto/:name/:age")
  function withParams(name : String, age : Int) {
    Assert.is(name, String);
    Assert.is(age, Int);
    response.send({name:name,age:age});
  }
}