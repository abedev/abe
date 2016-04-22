import js.node.http.ClientRequest;
import js.node.http.IncomingMessage;
import utest.Assert;
import abe.App;
import abe.Router;
import js.node.Http;
import js.node.http.*;
import js.node.Querystring;

class TestCalls {
  static var port = 42476;
  public function new() {}

  var app : App;
  var router : Router;
  var server : js.node.http.Server;
  public function setup() {
    app = new App();
    router = app.router;
    server = app.http(port);
  }

  public function teardown() {
    server.close();
  }

  function get(path : String, ?headers : {}, callback : String -> IncomingMessage -> Void)
    request(path, Get, null, headers, callback);

  function post(path : String, body : {}, ?headers : {}, callback : String -> IncomingMessage -> Void)
    request(path, Post, body, headers, callback);

  function put(path : String, body : {}, ?headers : {}, callback : String -> IncomingMessage -> Void)
    request(path, Put, body, headers, callback);

  function delete(path : String, ?headers : {}, callback : String -> IncomingMessage -> Void)
    request(path, Delete, null, headers, callback);

  function request(path : String, method : Method, ?payload : {}, ?headers : {}, callback : String -> IncomingMessage -> Void) {
    var done = Assert.createAsync(2000);
    var r : ClientRequest = null;

    r = Http.request({
        host : "localhost",
        port : port,
        method : method,
        path : path,
        headers : headers
      }, function(msg : IncomingMessage) {
        var data = "";
        msg.on("data", function(chunk) {
          data += chunk;
        });
        msg.on("end", function() {
          callback(data, msg);
          done();
        });
      });

    if (null != payload) {
      var b = Querystring.stringify(payload);
      r.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      r.setHeader('Content-Length', '${b.length}');
      r.write(b);
    } else {
      r.setHeader('Transfer-Encoding', 'chunked');
    }
    r.end();
  }
}
