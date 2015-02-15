package restx.core.macros;

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
import restx.core.macros.Macros.*;

class AutoRegisterRoute {
  public static function register(router : Expr, instance : Expr) : Expr {
    // get the type
    
    // iterate on all the fields and filter the functions that have @:path

    // for each iterate on all the HTTP methods (at least Get)

    // create a class type for each controller function

    // create processor instance

    // pass additional filters

    // registerMethod(path, method, router)
    return macro (function(instance) {

    })($instance);
  }
}