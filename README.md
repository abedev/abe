# restx

[![Join the chat at https://gitter.im/fponticelli/restx](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/fponticelli/restx?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
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