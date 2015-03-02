package abe.core;

import abe.core.filters.*;

class ArgumentsFilter {
  static var globalFilters : Array<IFilterArgument<Dynamic>> = [
    new DateFilter(),
    new IntFilter(),
    new FloatFilter(),
    new BoolFilter(),
    new StringFilter(),
    new ArrayStringFilter()
  ];

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
