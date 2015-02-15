# restx
Build REST apis with Haxe and nodejs.

WARNING: this is an experimental project and might be dropped at any time.

Example:

```haxe
import restx.App;

class Main implements restx.IRoute {
  @:path("/")
  function index()
    response.send("Hello World!");

  public static function main() {
    var app = new App(9998);
    app.router.register(new Main());
    app.start();
  }
}
```