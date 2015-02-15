package restx.core.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class Macros {
  public static function createVarField(name : String, type : ComplexType) : Field {
    return {
      name: name,
      access: [APublic],
      kind: FVar(type, null),
      pos: Context.currentPos()
    };
  }

  public static function createFunctionField(name : String, ?args : Array<FunctionArg>, ?ret : ComplexType, ?expr : Expr) : Field {
    return {
      name: name,
      access: [APublic],
      kind: FFun({
        ret  : null != ret ? ret : macro : Void,
        expr : null != expr ? expr : macro {},
        args : null != args ? args : []
      }),
      pos: Context.currentPos()
    };
  }

  public static function findClassField(fields : Array<ClassField>, name : String) {
    for(field in fields) {
      if(field.name == name)
        return field;
    }
    return null;
  }

  public static function hasField(fields : Array<Field>, name : String)
    return null != findField(fields, name);

  public static function findField(fields : Array<Field>, name : String) {
    for(field in fields)
      if(field.name == name)
        return field;
    return null;
  }

  public static function hasClassField(fields : Array<ClassField>, name : String)
    return findClassField(fields, name) != null;

  public static function hasFieldInHirearchy(type : ClassType, name : String) : Bool {
    if(name == "new") {
      if(null != type.constructor)
        return true;
    } else {
      trace(type.fields.get());
      if(hasClassField(type.fields.get(), name))
        return true;
    }
    var superClass = type.superClass;
    if(null == superClass) {
      return false;
    }
    return hasFieldInHirearchy(superClass.t.get(), name);
  }
}