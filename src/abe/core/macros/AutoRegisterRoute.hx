package abe.core.macros;

import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.TypeTools;
import abe.core.macros.Macros.*;
using thx.core.Iterables;
using thx.core.Arrays;
using thx.core.Strings;

class AutoRegisterRoute {
  public static function register(router : Expr, instance : Expr) : Expr {
    var type = getClassType(instance),
        prefix = getPrefix(type.meta.get(), type.pos),
        pos  = type.pos,
        meta = type.meta.get(),
        uses = getUses(meta),
        errors = getErrors(meta),
        filters = getFilters(meta);
    // iterate on all the fields and filter the functions that have @:{method}
    var fields = filterControllerMethods(type.fields.get());

    var definitions = fields.map(function(field) {
        var metadata = field.meta.get(),
            metas    = findMetaFromNames(metadata, abe.Methods.list),
            uses     = getUses(metadata),
            errors   = getErrors(metadata),
            filters  = getFilters(metadata);

        return metas.map(function(meta) {
          return {
            name: field.name,
            path: getMetaAsString(meta, 0),
            args: getArguments(field),
            method: meta.name.substring(1),
            uses: uses.map(ExprTools.toString),
            errors: errors.map(ExprTools.toString),
            filters: filters.map(ExprTools.toString)
          }
        });
      }).flatten();

    var exprs = [macro var router = parent.mount($v{prefix})];

    exprs = exprs.concat(uses.map(
      function(use) return macro router.use("/", $e{use})));

    if(filters.length > 0) {
      var sfilters = filters.map(ExprTools.toString);
      exprs.push(Context.parse('var commonFilters = [${sfilters.join(", ")}]',
          Context.currentPos()));
    }

    exprs = exprs.concat(definitions.map(function(definition) {
      // create a class type for each controller function
      var processName = [type.name, definition.name, "RouteProcess"].join("_");
      var fullName = type.pack.concat([processName]).join("."),
          exprs  = [];

      exprs.push(Context.parse('var filters = new abe.core.ArgumentsFilter()',
                Context.currentPos()));
      if(filters.length > 0) {
        filters
          .map(ExprTools.toString)
          .map(function(filter) {
            exprs.push(Context.parse('filters.addFilter($filter)',
              Context.currentPos()));
          });
      }
      for(filter in definition.filters)
        exprs.push(Context.parse('filters.addFilter($filter)', pos));
      var args = definition.args.map(function(arg) {
              var sources = arg.sources.map(function(s) return '"$s"').join(", ");
              return '{
                name     : "${arg.name}",
                optional : ${arg.optional},
                type     : "${arg.type}",
                sources : [$sources]
              }';
            }).join(", "),
          emptyArgs = definition.args.map(function(arg) return '${arg.name} : null').join(", ");
      exprs.push(Context.parse('var processor = new abe.core.ArgumentProcessor(filters, [${args}])', pos));
      exprs.push(Context.parse('var process = new $fullName({ $emptyArgs }, instance, processor)', pos));
      exprs.push(Context.parse('router.registerMethod("${definition.path}", "${definition.method}", cast process, [${definition.uses.join(", ")}], [${definition.errors.join(", ")}])', pos));

      var params = definition.args.map(function(arg) : Field{
          var kind = complexTypeFromString(arg.type);
          return {
            pos : Context.currentPos(),
            name : arg.name,
            kind : FVar(kind)
          };
        });

      if(null == try Context.getType(processName) catch(e : Dynamic) null) {
        var fields = createProcessFields(definition.name, definition.args);
        Context.defineType({
            pos  : Context.currentPos(),
            pack : type.pack,
            name : processName,
            kind : TDClass({
                pack : ["abe", "core"],
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

      return exprs;
    }).flatten());

  exprs = exprs.concat(errors.map(
    function(error) return macro router.error($e{error})));

  exprs.push(macro return router);
    var result = macro (function(instance, parent : abe.Router)
      $b{exprs}
    )($instance, $router);
    return result;
  }

  static function complexTypeFromString(s : String) : ComplexType {
    return switch Context.parse('(_:$s)', Context.currentPos()) {
      case { expr : EParenthesis({ expr : ECheckType(_, t) }) }: t;
      case _: throw 'screw you';
    };
  }

  static function getEntries(name : String, meta : Array<MetadataEntry>) {
    var m = findMeta(meta, name);
    if(null == m) return [];
    return m.params;
  }

  static function getUses(meta : Array<MetadataEntry>)
    return getEntries(":use", meta);

  static function getErrors(meta : Array<MetadataEntry>)
    return getEntries(":error", meta);

  static function getFilters(meta : Array<MetadataEntry>)
    return getEntries(":filter", meta);

  static function getPrefix(meta : Array<MetadataEntry>, pos) {
    var m = findMeta(meta, ":path");
    if(null == m) return "/";
    if(m.params.length != 1)
      Context.error("@:path() should only contain one string", pos);
    return switch m.params[0].expr {
      case EConst(CString(path)):
        path;
      case _:
        Context.error("@:path() should use a string", pos);
    };
  }

  static function getClassType(expr : Expr) return switch Context.follow(Context.typeof(expr)) {
    case TInst(t, _) if(classImplementsInterface(t.get(), "abe.IRoute")): t.get();
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
        if (!abe.Methods.list.any(function (method) return method == find)) {
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
    sources.map(function(source : Source) switch source {
        case Query, Params, Body, Request:
        case _: Context.error('"$source" is not a valid @:source()', field.pos);
      });
    return sources;
  }
}
