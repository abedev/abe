# abe

[![Join the chat at https://gitter.im/abedev/abe](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/abedev/abe?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Build REST apis with Haxe and nodejs.

WARNING: this is an experimental project and might be dropped at any time.


### Setup

Create a new instance of a `abe.App`, which listens for http traffic on a port of your choice:

```haxe
import abe.App;

class Main {
  public static function main() {
    var app = new App();
    app.router.register(new RouteHandler());
    app.http(9998); // running on port 9998
  }
}
```

The above code registers all routes in your `RouteHandler` class, which could look something like this:

```haxe
class RouteHandler implements abe.IRoute {
  @:get("/")
  function index()
    response.send("Hello World!");
}
```

### Routes

TODO

By default arguments are taken from `params` (the route path) but with the `@:args()` meta you can take the arguments from: `query`, `body` or `params`. @:args can also take an array of sources when multiple sources are desired. Sources can be specified as either identifiers (no quotes) or strings.

#### Basic HTTP Methods

The example above used `@:get` to tell the function below to handle GET requests on the `/` route. In addition to `get`, you can use [a variety of other HTTP methods](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html).

```haxe
@:delete("/user/:id")
function deleteUser(id : Int) {
  // delete user whose id is `id`
}
```

#### HEAD and OPTIONS

Out of the box, `HEAD` requests will return headers for any route you specify, and `OPTIONS /some/path` will return a list of methods that are accepted by the path `/some/path`. This happens without the need to manually specify `@:head` and `@:options`.

However, do note that making a `HEAD` request to a URL will run the `@:get` handler function, even though only the headers are returned. If you have an expensive function handling `GET` requests, you may wish to specify a separate `@:head` handler like so:

```haxe
@:head("/user")
function getUserHead () {
  response.sendStatus(200).end();
}
```

#### Multiple Routes, One Handler

You can use a single route to handle a variety of types of requests (to a variety of paths, if you choose).

```haxe
@:post("/user")
@:put("/user")
function createOrUpdateUser() {}
```

Note: you can't use the pattern above to handle the same http verb with two different paths. This is because multiple metadata with the same name will cause all but the first to be ignored.

```haxe
// WILL NOT WORK
@:get("/user")
@:get("/some/other/path")
function aSingleHandler() {}
```

In addition to traditional HTTP verbs, you can use the special keyword `all` to handle all types of HTTP traffic on a route.

```haxe
@:all("/foo")
function handleAllFooTraffic() {
    if (request.method.toLowerCase() == "get") {
        // do something
    } else {
        // do some other thing
    }
}
```

