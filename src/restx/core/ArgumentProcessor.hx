package restx.core;

import restx.core.ArgumentProcessing;
import restx.core.ArgumentRequirement;
import restx.core.ArgumentsFilter;
using thx.core.Either;
using thx.core.Types;
using haxe.ds.Option;

class ArgumentProcessor<TArgs : {}> {
  var requirements : Array<ArgumentRequirement>;
  var filters : ArgumentsFilter;
  public function new(?filters : ArgumentsFilter, requirements : Array<ArgumentRequirement>) {
    this.filters = null != filters ? filters : new ArgumentsFilter();
    this.requirements = requirements;
    this.filters.checkRequirements(requirements);
  }

  public function processArguments(source : { params : {}, query : {}, body : {} }, results : TArgs) : ArgumentProcessing {
    for(r in requirements) {
      switch getValue(r.name, source, r.sources) {
        case Some(v):
          switch filters.getFilterType(r.type).filter(v) {
            case Right(value):
              Reflect.setField(results, r.name, value);
            case Left(error):
              return InvalidType('invalid type for param ${r.name}');
          }
        case None:
          if(r.optional) {
            Reflect.setField(results, r.name, null);
          } else {
            return Required('param ${r.name} is required');
          }
      }
    }
    return Ok;
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