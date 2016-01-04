package abe.core.macros;

import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.TypeTools;
import abe.core.macros.Macros.*;
using thx.Iterables;
using thx.Arrays;
using thx.Strings;

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
            ises     = getIses(metadata),
            errors   = getErrors(metadata),
            filters  = getFilters(metadata),
            validates = getValidations(metadata);

        return metas.map(function(meta) {
          var args = getArguments(field);
          return {
            name: field.name,
            path: getMetaAsString(meta, 0),
            args: args,
            method: meta.name.substring(1),
            uses: uses.map(ExprTools.toString),
            ises: ises.map(ExprTools.toString),
            errors: errors.map(ExprTools.toString),
            filters: filters.map(ExprTools.toString),
            validates: validates.mapi(function(validate, i) {
              var a = args[i];
              return generateValidateFunction(validate, null != a ? a.type : null);
            })
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
      var valueArgs = definition.args,
          args = valueArgs.map(function(arg) {
              var sources = arg.sources.map(function(s) return '"$s"').join(", ");
              return '{
                name     : "${arg.name}",
                optional : ${arg.optional},
                type     : "${arg.type}",
                sources : [$sources]
              }';
            }).join(", "),
          emptyArgs = valueArgs.map(function(arg) return '${arg.name} : null').join(", "),
          validates = definition.validates.mapi(function(val, i) {
            var name = valueArgs[i].name,
                sources = valueArgs[i].sources.map(function(s) return '"$s"').join(", ");
            var f = '\nfunction (req : express.Request, res : express.Response, next : express.Next) {
  var f = $val;
  if (f == null) {
    next.call();
    return;
  }
  switch abe.core.ArgumentProcessor.getValue("$name", req, [$sources]) {
    case None:
      next.error(new js.Error("argument not found $name"));
      return;
    case Some(value):
      f(value, req, res, next);
  }
}';
            return f;
          });

      exprs.push(Context.parse('var __abe_processor = new abe.core.ArgumentProcessor(filters, [${args}])', pos));
      exprs.push(Context.parse('var __abe_process = new $fullName({ $emptyArgs }, instance, __abe_processor)', pos));
      exprs.push(Context.parse('var __abe_uses : Array<express.Middleware> = []', pos));
      if(definition.ises.length > 0) {
        var ises = "[" + definition.ises.join(", ") + "]";
        ises = 'function(req : express.Request, res : express.Response, next : express.Next) {
            if(req.is($ises))
              next.call();
            next.route();
          }';
        exprs.push(Context.parse('__abe_uses = __abe_uses.concat([$ises])', pos));
      }
      if(definition.uses.length > 0)
        exprs.push(Context.parse('__abe_uses = __abe_uses.concat([${definition.uses.join(", ")}])', pos));
      if(validates.length > 0)
        exprs.push(Context.parse('__abe_uses = __abe_uses.concat([${validates.join(", ")}])', pos));
      exprs.push(Context.parse('router.registerMethod("${definition.path}", "${definition.method}", cast __abe_process, __abe_uses, [${definition.errors.join(", ")}])', pos));

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

  static function generateValidateFunction(f : Expr, type) {
    var t = try Context.follow(Context.typeof(f)) catch(e : Dynamic) null;
    if(null == t) {
      return 'function(value : $type, req : express.Request, res : express.Response, next : express.Next) {
  var fn = function(_ : $type) : Bool return ${ExprTools.toString(f)};
  if(null == value || fn(value)) {
    next.call();
  } else {
    var err = new js.Error("cannot validate "+value);
    untyped err.status = 400;
    next.error(err);
  }
}';
    }
    return switch t {
      case TFun(args, TAbstract(ret,_)) if(args.length == 1 && ret.toString() == "Bool"): // straight validate
        var sf = ExprTools.toString(f);
        return 'function(value : $type, req : express.Request, res : express.Response, next : express.Next) {
  var fn = $sf;
  if(null == value || fn(value)) {
    next.call();
  } else {
    var err = new js.Error("cannot validate "+value);
    untyped err.status = 400;
    next.error(err);
  }
}';
      case TFun(args, TAbstract(ret,_)) if(args.length == 4 && ret.toString() == "Void"): // complex validate
        ExprTools.toString(f);
      case TMono(v):
        "null";
      case s:
        Context.error('invalid expression @:validate(${ExprTools.toString(f)})', f.pos);
    }
  }

  static function complexTypeFromString(s : String) : ComplexType {
    return switch Context.parse('(_:$s)', Context.currentPos()) {
      case { expr : EParenthesis({ expr : ECheckType(_, t) }) }: t;
      case _: throw 'screw you';
    };
  }

  static function getEntries(name : String, meta : Array<MetadataEntry>)
    return findMetas(meta, name).map(function(m) return m.params).flatten();

  static function getIses(meta : Array<MetadataEntry>)
    return getEntries(":is", meta);

  static function getUses(meta : Array<MetadataEntry>)
    return getEntries(":use", meta);

  static function getErrors(meta : Array<MetadataEntry>)
    return getEntries(":error", meta);

  static function getFilters(meta : Array<MetadataEntry>)
    return getEntries(":filter", meta);

  static function getValidations(meta : Array<MetadataEntry>)
    return getEntries(":validate", meta);

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
          }).concat(["request", "response", "next"]).join(", "),
        execute = 'instance.$name($args)';
    return [createFunctionField("execute",
      [AOverride],
      [
        { name : "request", type : macro : express.Request, value : null, opt : false },
        { name : "response", type : macro : express.Response, value : null, opt : false },
        { name : "next", type : macro : express.Next, value : null, opt : false }
      ],
      Context.parse(execute, Context.currentPos()))];
  }

  static function getArguments(field : ClassField) : Array<ArgumentRequirement> {
    return switch Context.follow(field.type) {
      case TFun(args, _):
        args.slice(0, args.length - 3).map(function(arg) {
          return {
            name : arg.name,
            optional : arg.opt,
            type : arg.t.toString(),
            sources : getSources(field, arg.name)
          };
        });
      case _: [];
    };
  }

  static function getSources(field : ClassField, argName : String) {
    var meta = findMeta(field.meta.get(), ":args");
    if(null == meta)
      return ["params"];
    var sources = meta.params.map(function(p) return switch p.expr {
      case EConst(CIdent(id)), EConst(CString(id)),
           ECall({ expr : EConst(CIdent(id)), pos : _ }, []):
        [id.toLowerCase()];
      case EArrayDecl(arr): arr.map(function(p) return switch p.expr {
          case EConst(CIdent(id)): id.toLowerCase();
          case _: Context.error("parameter for query should be an identifier or an array of identifiers", field.pos);
        });
      case ECall({ expr : EConst(CIdent(source)), pos : _ }, args):
        args.filter(function(arg) {
          return switch arg.expr {
            case EConst(CIdent(argId)) if(argId == argName): true;
            case _: false;
          };
        }).map(function(_) return source.toLowerCase());
      case other:
        trace(other);
        Context.error("parameter for query should be an identifier or an array of identifiers", field.pos);
    }).flatten();
    sources.map(function(source : Source) switch source {
        case Query, Params, Body, Request:
        case _: Context.error('"$source" is not a valid @:source()', field.pos);
      });
    return sources;
  }
}
