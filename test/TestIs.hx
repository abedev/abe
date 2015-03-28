import express.Error;
import express.Next;
import express.Request;
import express.Response;
import routes.*;
import utest.Assert;

class TestIs extends TestCalls {
  public function testIs() {
    router.register(new Is());

    get("/",
      { "Content-Type" : "text/html" },
      function (msg, r) {
        Assert.stringContains("text/html", Reflect.field(r.headers, "content-type"));
        Assert.equals("<html></html>", msg);
      });

    get("/",
      { "Content-Type" : "application/json" },
      function (msg, r) {
        Assert.stringContains("application/json", Reflect.field(r.headers, "content-type"));
        Assert.equals("{\"name\":\"is\"}", msg);
      });
  }
}

class Is implements abe.IRoute {
  @:get("/")
  @:is("html", "text/plain")
  function getHtml() {
    response.send('<html></html>');
  }

  @:get("/")
  @:is("json")
  function getJson() {
    response.send({ name : "is" });
  }
}
