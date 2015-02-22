package abe.core.filters;

import thx.promise.Promise;

class StringFilter implements IFilterArgument<String> {
  public function new(){}

  public var type = "String";
  public function filter(value : String) : Promise<String>
    return Promise.value(value);
}
