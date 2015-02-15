package restx.core.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import Type in RType;

class Macros {
  public static function createVarField(name : String, type : ComplexType) : Field {
    return {
      name: name,
      access: [APublic],
      kind: FVar(type, null),
      pos: Context.currentPos()
    };
  }

  public static function createFunctionField(name : String, ?access : Array<Access>, ?args : Array<FunctionArg>, ?ret : ComplexType, ?expr : Expr) : Field {
    return {
      name: name,
      access: null != access ? access : [APublic],
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

  public static function findMeta(meta : Array<MetadataEntry>, name : String) {
    if(null == meta)
      return null;
    for(m in meta)
      if(m.name == name)
        return m;
    return null;
  }

  public static function hasMeta(meta : Array<MetadataEntry>, name : String)
    return findMeta(meta, name) != null;

  public static function getMetaAsString(meta : MetadataEntry, pos : Int) {
    if(null == meta.params[pos])
      return null;
    return switch meta.params[pos].expr {
      case EConst(CString(s)): s;
      case _: null;
    };
  }

  public static function makeFieldPublic(field : Field) {
    if(isPublic(field)) return;
    field.access.push(APublic);
  }

  public static function isPublic(field : Field) {
    for(a in field.access)
      if(RType.enumEq(a, APublic))
        return true;
    return false;
  }
}