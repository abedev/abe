package restx.core.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import restx.core.macros.Macros.*;

class BuildIRoute {
  macro public static function complete() : Array<Field> {
    var fields = Context.getBuildFields();
    injectConstructor(fields);
    injectToString(fields);
    injectRequest(fields);
    injectResponse(fields);
    injectNext(fields);
    makeControllerFunctionsPublic(fields);
    return fields;
  }

  static function injectConstructor(fields : Array<Field>) {
    if(hasField(fields, "new")) return;
    fields.push(createFunctionField("new"));
  }

  static function injectToString(fields : Array<Field>) {
    if(hasField(fields, "toString")) return;
    var cls = Context.getLocalClass().toString();
    fields.push(createFunctionField("toString", macro : String, macro return $v{cls}));
  }

  static function injectRequest(fields : Array<Field>) {
    if(hasField(fields, "request")) return;
    fields.push(createVarField("request", macro : express.Request));
  }

  static function injectResponse(fields : Array<Field>) {
    if(hasField(fields, "response")) return;
    fields.push(createVarField("response", macro : express.Response));
  }

  static function injectNext(fields : Array<Field>) {
    if(hasField(fields, "next")) return;
    fields.push(createVarField("next", macro : express.Next));
  }

  static function makeControllerFunctionsPublic(fields : Array<Field>) {
    for(field in fields) {
      for (method in ["get", "post", "head", "options", "put", "delete", "trace", "connect"])
        if(hasMeta(field.meta, ":" + method))
          makeFieldPublic(field);
    }
  }
}