package abe;
import abe.Method;

#if macro
import haxe.macro.Expr;
#else
import express.Express;
import express.Middleware;
import express.Router in R;
import haxe.Constraints.Function;
import abe.core.RouteProcess;
#end

class Router {
#if !macro
  public var expressRouter(default, null) : R;
  public function new(expressRouter : R) {
    this.expressRouter = expressRouter;
  }

  public function mount(path : String) {
    var newrouter = new R();
    expressRouter.use(path, newrouter);
    return new Router(newrouter);
  }

  public function use(?path : String, middleware : Middleware) {
    if(null == path)
      expressRouter.use(middleware);
    else
      expressRouter.use(path, middleware);
    return this;
  }

  public function error(middleware : ErrorMiddleware) {
    expressRouter.use(middleware);
    return this;
  }

  public function registerMethod(path : String, method : Method, process : RouteProcess<IRoute, {}>, ?middlewares : Array<Middleware>, ?errorMiddlewares : Array<ErrorMiddleware>) {
    var args : Array<Dynamic> = [path];
    if(null != middlewares) {
      args = args.concat(middlewares);
    }
    args.push(process.run);
    if(null != errorMiddlewares) {
      args = args.concat(errorMiddlewares);
    }
    Reflect.callMethod(
      expressRouter,
      Reflect.field(expressRouter, method), args);
    return this;
  }

  public function serve(path : String, root : String, ?options : express.StaticOptions) {
    expressRouter.use(path, Express.serveStatic(root, options));
    return this;
  }
#end
  macro public function register(_this : Expr, instance : Expr)
    return abe.core.macros.AutoRegisterRoute.register(_this, instance);
}
