import utest.Assert;

import js.node.Http;
import js.node.http.IncomingMessage;

class TestCalls {
  var port : Int;
  public function new(port : Int) {
    this.port = port;
  }

  public function testIndex() {
    request("/", "GET", function(msg) {
      Assert.equals('"Hello World"', msg);
    });
  }

  function request(path : String, method : String, callback : String -> Void) {
    var done = Assert.createAsync(2000);
    Http.request({
        host : "localhost",
        port : port,
        method : method,
        path : path
      }, function(msg : IncomingMessage) {
        var data = "";
        msg.on("data", function(chunk) {
          data += chunk;
        });
        msg.on("end", function() {
          callback(data);
          done();
        });
      }).end();
  }
}