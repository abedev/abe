package abe.core;

import abe.core.filters.*;

class ArgumentsFilter {
  static var globalFilters : Array<IFilterArgument<Dynamic>> = (function() {
      var filters : Array<IFilterArgument<Dynamic>> = [],
          bool   = new BoolFilter(),
          date   = new DateFilter(),
          dt     = new DateTimeFilter(),
          dtutc  = new DateTimeUtcFilter(),
          float  = new FloatFilter(),
          int    = new IntFilter(),
          ldate  = new LocalDateFilter(),
          string = new StringFilter(),
          object = new ObjectFilter();

      filters.push(bool);
      filters.push(date);
      filters.push(dt);
      filters.push(dtutc);
      filters.push(float);
      filters.push(int);
      filters.push(ldate);
      filters.push(string);
      filters.push(object);
      filters.push(new ArrayFilter("Bool", ",", bool));
      filters.push(new ArrayFilter("Date", ",", date));
      filters.push(new ArrayFilter("thx.DateTime", ",", dt));
      filters.push(new ArrayFilter("thx.DateTimeUtc", ",", dtutc));
      filters.push(new ArrayFilter("thx.LocalDate", ",", ldate));
      filters.push(new ArrayFilter("Float", ",", float));
      filters.push(new ArrayFilter("Int", ",", int));
      filters.push(new ArrayFilter("String", ",", string));
      filters.push(new ArrayFilter("{}", "|", object));
      return filters;
    })();

  public static function registerFilter(filter : IFilterArgument<Dynamic>)
    globalFilters.push(filter);

  var filters : Map<String, IFilterArgument<Dynamic>>;
  public function new() {
    filters = new Map();
    globalFilters.map(addFilter);
  }

  public function addFilter(filter : IFilterArgument<Dynamic>) {
    if(null == filter.type) throw 'Invalid null parameter IFilterArgument.typeName';
    filters.set(filter.type, filter);
  }

  public function canFilterType(type : String) {
    return filters.exists(type);
  }

  public function getFilterType(type : String) {
    return filters.get(type);
  }

  public function checkRequirements(requirements : Array<ArgumentRequirement>) {
    for(requirement in requirements)
      if(!canFilterType(requirement.type))
        throw 'No filter is specified for type ${requirement.type}';
  }
}
