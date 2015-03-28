# abe
[![Join the chat at https://gitter.im/abedev/abe](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/abedev/abe?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Build REST apis with Haxe and nodejs.

## Setup
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

## Routes
abe makes super-easy getting typed parameters from user requests:

```haxe
@:get("/user/:id")
function getUser(id : Int) {
  // do something with `id`
}
```

In this case `getUser` is only invoked if `:id` is present and it is an integer value. If those rules are not satisfied, the routing process continues to the next handler. Multiple parameters are possible as are custom filter (ex: get the user object directly as a parameter instead of the `id`).

By default arguments are taken from `params` (the route path) but with the `@:args()` meta you can take the arguments from: `query`, `body`, `params` or `request`. @:args can also take an array of sources when multiple sources are desired. Sources can be specified as either identifiers (no quotes) or strings.

### Basic HTTP Methods
The example above used `@:get` to tell the function below to handle GET requests on the `/` route. In addition to `get`, you can use [a variety of other HTTP methods](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html).

```haxe
@:delete("/user/:id")
function deleteUser(id : Int) {
  // delete user whose id is `id`
}
```

### HEAD and OPTIONS
Out of the box, `HEAD` requests will return headers for any route you specify, and `OPTIONS /some/path` will return a list of methods that are accepted by the path `/some/path`. This happens without the need to manually specify `@:head` and `@:options`.

However, do note that making a `HEAD` request to a URL will run the `@:get` handler function, even though only the headers are returned. If you have an expensive function handling `GET` requests, you may wish to specify a separate `@:head` handler like so:

```haxe
@:head("/user")
function getUserHead () {
  response.sendStatus(200).end();
}
```

### Multiple Routes, One Handler
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

### @:path
You can set a base path for your handlers by adding the `@:path()` to your class.

```haxe
@:path("/some/")
class SomeRoute implements IRoute {
  @:get("/endpoint/")
  function getEndpoint() {
    // do something
  }
}
```

The handler `getEndpoint` responds to calls made at path `/some/endpoint/`.

### @:use
One of the most powerful features of Express is to be able to use [middlewares](http://expressjs.com/guide/using-middleware.html). _abe_ makes using middleware super easy to use either at the handler level (methods), class level (router) or application level (`abe.App`).

In the first two cases you can just apply the `@:use` metadata with a reference to a static method satisfies the `express.Middleware` signature.

```haxe
@:use(express.mw.BodyParser.json())
```

The metadata makes very easy to apply Middleware to just very specific handlers. You should take advantage of that feature instead of blindly apply Middleware globally. Still in case you want to do that you can apply the Middleware to the entire app or router.

```haxe
var app = new abe.App();
app.use(express.mw.BodyParser.json());
```

TODO documentation:
- class level meta
  - [ ] @:validate
  - [ ] @:filter
  - [ ] @:error

- handler level meta
  - [ ] @:validate
  - [ ] @:filter
  - [ ] @:error
