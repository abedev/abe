package abe.core;

import abe.core.ArgumentProcessing;
using haxe.ds.Option;
import thx.fp.Functions.const;
using thx.promise.Future;
using thx.promise.Promise;
using thx.Strings;

class ArgumentProcessor<TArgs : {}> {
  var requirements : Array<ArgumentRequirement>;
  var filters : ArgumentsFilter;
  public function new(?filters : ArgumentsFilter, requirements : Array<ArgumentRequirement>) {
    this.filters = null != filters ? filters : new ArgumentsFilter();
    this.requirements = requirements.map(cleanUpRequirementType);
    this.filters.checkRequirements(requirements);
  }

  public function processArguments(source : { params : {}, query : {}, body : {} }, results : TArgs) : Future<ArgumentProcessing> {
    var promises = [];
    for(r in requirements) {
      switch getValue(r.name, source, r.sources) {
        case Some(v):
          var future = filters.getFilterType(r.type).filter(v);
          promises.push(future.success(
            function(value) Reflect.setField(results, r.name, value)));
        case None if(r.optional):
          Reflect.setField(results, r.name, null);
        case None:
          return Future.value(Required(r.name));
      }
    }

    return Promise.sequence(promises).mapEitherFuture(const(Ok), InvalidFilter);
  }

  public static function getValue(name : String, source : { params : {}, query : {}, body : {} }, sources : Array<Source>) : Option<Dynamic> {
    var o, value;
    for(sourceName in sources) {
      var o = switch sourceName {
        case Request: source;
        case Body: source.body;
        case Params: source.params;
        case Query: source.query;
      }
      if(null == o) continue;
      value = Reflect.field(o, name);
      if(null != value)
        return Some(value);
    }
    return None;
  }

  static function cleanUpRequirementType(requirement : ArgumentRequirement) {
    var type = requirement.type;
    // remove spaces
    type = type.replace(" ", "");
    // remove wrapping Null
    if(type.startsWith("Null<"))
      type = type.substring(5, type.length - 1);
    requirement.type = type;
    return requirement;
  }
}
