package abe;

#if !macro
import express.Middleware;
import js.node.Http;
import js.node.Https;
import js.node.Tls.TlsServerOptions;
import express.Express;
#end

class App {
#if !macro
  public var router(default, null) : Router;
  public var express(default, null) : Express;

  public function new(?options : Options) {
    options = null != options ? options : {};
    express = new Express();

    if(options.strictRoute)
      express.set("strict route", true);
    if(options.caseSensitiveRouting)
      express.set("case sensitive routing", true);

    express.set("x-powered-by", false);

    var r  = new express.Router();
    express.use("/", r);
    router = new Router(r);
  }

  public function sub(path : String) {
    var sub = new App();
    express.use(path, sub.express);
    return sub;
  }

  public function http(port : Int, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = Http.createServer(cast express);
    server.listen(port, host, backlog, callback);
    return server;
  }

  public function https(port : Int, options : TlsServerOptions, ?host : String, ?backlog : Int, ?callback : Void -> Void) {
    var server = Https.createServer(options, cast express);
    server.listen(port, host, backlog, callback);
    return server;
  }

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
