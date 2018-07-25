package abe;

#if !macro
import express.Middleware;
import js.node.Http;
import js.node.Https;
import js.node.Tls.TlsCreateServerOptions;
import express.Express;
#end

class App {
#if !macro
  public var router(get, null) : Router;
  public var express(default, null) : Express;

  public function new(?options : Options) {
    options = null != options ? options : {};
    express = new Express();

    if(options.strictRoute)
      express.set("strict route", true);
    if(options.caseSensitiveRouting)
      express.set("case sensitive routing", true);

    express.set("x-powered-by", false);
  }

  public function sub(path : String) {
    var sub = new App();
    express.use(path, sub.express);
    return sub;
  }

  public function http(port : Int, ?host : String, ?backlog : Int, ?callback : Void -> Void) : js.node.http.Server {
    var server = httpServer();
    server.listen(port, host, backlog, callback);
    return server;
  }

  public function httpServer() : js.node.http.Server
    return Http.createServer(cast express);

  public function https(port : Int, options : TlsCreateServerOptions, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = httpsServer(options);
    server.listen(port, host, backlog, callback);
    return server;
  }

  public function httpsServer(options:TlsCreateServerOptions) : js.node.https.Server
    return Https.createServer(options, cast express);

  public function use(?path : String, middleware : Middleware) {
    if(null == path)
      express.use(middleware);
    else
      express.use(path, middleware);
    return this;
  }

  public function error(middleware : ErrorMiddleware) {
    express.use(middleware);
    return this;
  }

  function get_router():Router {
    if (router == null) {
        var r  = new express.Router();
        express.use("/", r);
        router = new Router(r);
    }

    return router;
  }

#end
  macro public static function installNpmDependencies(?createPackageJson : Bool) {
    if(null == createPackageJson)
      createPackageJson = true;
    jsrequire.JSRequire.installNpmDependencies(createPackageJson);
    return macro null;
  }
}

typedef Options = {
  ?strictRoute : Bool,
  ?caseSensitiveRouting : Bool
}
