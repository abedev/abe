package restx.core;

import restx.core.ArgumentProcessing;
import restx.core.ArgumentRequirement;
import restx.core.ArgumentsFilter;
using thx.core.Either;
using thx.core.Types;
using thx.promise.Future;
using thx.promise.Promise;
using haxe.ds.Option;

class ArgumentProcessor<TArgs : {}> {
  var requirements : Array<ArgumentRequirement>;
  var filters : ArgumentsFilter;
  public function new(?filters : ArgumentsFilter, requirements : Array<ArgumentRequirement>) {
    this.filters = null != filters ? filters : new ArgumentsFilter();
    this.requirements = requirements;
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

    return Promise.all(promises).mapEither(
      function(_) {
        return Ok;
      },
      function(err) {
        // TODO change String to Error
        return InvalidFilter(err.toString());
      });
  }

  static function getValue(name : String, source : { params : {}, query : {}, body : {} }, sources : Array<Source>) {
    var o, value;
    for(sourceName in sources) {
      o = Reflect.field(source, sourceName);
      if(null == o) continue;
      value = Reflect.field(o, name);
      if(null != value)
        return Some(value);
    }
    return None;
  }
}