# restx
Build REST apis with Haxe and nodejs.

WARNING: this is an experimental project and might be dropped at any time.

Example:

```haxe
import restx.App;

class Main implements restx.IRoute {
  @:get("/")
  function index()
    response.send("Hello World!");

  public static function main() {
    var app = new App(9998);
    app.router.register(new Main());
    app.start();
  }
}
```

Using `@:get("/path")` will set the following function to handle GET requests on the `/path` route. In addition to `get`, you can create handlers for `post`, `put`, and `delete` requests, as well as [a variety of other HTTP methods](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html).
