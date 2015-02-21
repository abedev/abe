package abe.core.filters;

import thx.core.Ints;
import thx.core.Error;
import thx.promise.Promise;

class IntFilter implements IFilterArgument<Int> {
  public function new(){}

  public var type = "Int";
  public function filter(value : String) : Promise<Int> {
    if(Ints.canParse(value))
      return Promise.value(Ints.parse(value));
    else
      return Promise.error(new Error('"$value" is not an Integer value'));
  }
}