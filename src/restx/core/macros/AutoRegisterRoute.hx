package restx.core.macros;

import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.TypeTools;
import restx.core.macros.Macros.*;
using thx.core.Iterables;
using thx.core.Arrays;
using thx.core.Strings;

class AutoRegisterRoute {
  public static function register(router : Expr, instance : Expr) : Expr {
    var type = getClassType(instance),
        prefix = getPrefix(type.meta.get(), type.pos);

    // iterate on all the fields and filter the functions that have @:{method}
    var fields = filterControllerMethods(type.fields.get());

    var definitions = fields.map(function(field) {
        var metadata = field.meta.get(),
            metas    = findMetaFromNames(metadata, restx.Methods.list);

        return metas.map(function(meta) {
          return {
            name: field.name,
            path: prefix + getMetaAsString(meta, 0),
            args: getArguments(field),
            method: meta.name.substring(1)
          }
        });
      }).flatten();

    if(definitions.length == 0) {
      Context.error("There are no controller methods defined in this class", Context.currentPos());
    }

    var exprs = definitions.map(function(definition) {
      // create a class type for each controller function
      var processName = [type.name, definition.name, "RouteProcess"].join("_");
      var fullName = type.pack.concat([processName]).join("."),
          exprs  = [];

      exprs.push(Context.parse('var filters = new restx.core.ArgumentsFilter()',
                Context.currentPos()));
      var args = definition.args.map(function(arg) {
              var sources = arg.sources.map(function(s) return '"$s"').join(", ");
              return '{
                name     : "${arg.name}",
                optional : ${arg.optional},
                type     : "${arg.type}",
                sources : [$sources]
              }';
            }).join(", "),
          emptyArgs = definition.args.map(function(arg) {
              return '${arg.name} : null';
            }).join(", ");
      exprs.push(Context.parse('var processor = new restx.core.ArgumentProcessor(filters, [${args}])',
                Context.currentPos()));
      exprs.push(Context.parse('var process = new $fullName({ $emptyArgs }, instance, processor)',
                Context.currentPos()));

      var path = definition.path,
          method = definition.method;
      exprs.push(macro router.registerMethod($v{path}, $v{method}, cast process));

      var params = definition.args.map(function(arg) : Field return {
            pos : Context.currentPos(),
            name : arg.name,
            kind : FVar(Context.follow(Context.getType(arg.type)).toComplexType())
          });

      if(null == Context.getType(processName)) {
        var fields = createProcessFields(definition.name, definition.args);
        Context.defineType({
            pos  : Context.currentPos(),
            pack : type.pack,
            name : processName,
            kind : TDClass({
                pack : ["restx"],
                name : "RouteProcess",
                params : [
                  TPType(TPath({
                    sub : type.name,
                    pack : type.pack,
                    name : type.module.split(".").pop()
                  })),
                  TPType(TAnonymous(params))]
              }, [], false),
            fields : fields,
          });
      }

      // pass additional filters
      return macro $b{exprs};
    });

    // registerMethod(path, method, router)
    return macro (function(instance, router) {
      $b{exprs}
    })($instance, $router);
  }

  static function getPrefix(meta : Array<MetadataEntry>, pos) {
    var m = findMeta(meta, ":path");
    if(null == m) return "";
    if(m.params.length != 1)
      Context.error("@:path() should only contain one string", pos);
    return switch m.params[0].expr {
      case EConst(CString(path)):
        path = path.trimChars('/');
        path.length == 0 ? "" : '/$path';
      case _:
        Context.error("@:path() should use a string", pos);
    };
  }

  static function getClassType(expr : Expr) return switch Context.follow(Context.typeof(expr)) {
    case TInst(t, _) if(classImplementsInterface(t.get(), "restx.IRoute")): t.get();
    case _: Context.error('expression in Router.register must be an instance of an IRoute', Context.currentPos());
  }

  static function classImplementsInterface(cls : ClassType, test : String) {
    for(interf in cls.interfaces) {
      if(test == interf.t.toString())
        return true;
    }
    return false;
  }

  static function filterControllerMethods(fields : Array<ClassField>) {
    var results = [];
    for(field in fields) {
      for(meta in field.meta.get()) {
        var find = meta.name.substring(1);
        if (!restx.Methods.list.any(function (method) return method == find)) {
          continue;
        }
        results.push(field);
        break;
      }
    }
    return results;
  }

  static function createProcessFields(name : String, args : Array<ArgumentRequirement>) {
    var args = args.map(function(arg) {
            return 'args.${arg.name}';
          }).join(", "),
        execute = 'instance.$name($args)';
    return [createFunctionField("execute", [AOverride], Context.parse(execute, Context.currentPos()))];
  }

  static function getArguments(field : ClassField) : Array<ArgumentRequirement> {
    return switch Context.follow(field.type) {
      case TFun(args, _):
        args.map(function(arg) {
          return {
              name : arg.name,
              optional : arg.opt,
              type : arg.t.toString(),
              sources : getSources(field)
          };
        });
      case _: [];
    };
  }

  static function getSources(field : ClassField) {
    var meta = findMeta(field.meta.get(), ":args");
    if(null == meta)
      return ["params"];
    var sources = meta.params.map(function(p) return switch p.expr {
      case EConst(CIdent(id)), EConst(CString(id)):
        [id.toLowerCase()];
      case EArrayDecl(arr): arr.map(function(p) return switch p.expr {
          case EConst(CIdent(id)): id.toLowerCase();
          case _: Context.error("parameter for query should be an identifier or an array of identifiers", field.pos);
        });
      case _:
        Context.error("parameter for query should be an identifier or an array of identifiers", field.pos);
    }).flatten();
    sources.map(function(source) switch source {
        case "query", "params", "body":
        case _: Context.error('"$source" is not a valid @:source()', field.pos);
      });
    return sources;
  }
}