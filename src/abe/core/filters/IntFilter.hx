package abe.core.filters;

import thx.core.Ints;
import thx.core.Error;
import thx.promise.Promise;

class IntFilter implements IFilterArgument<Int> {
  public function new(){}

  public var type = "Int";
  public function filter(value : Dynamic) : Promise<Int> {
    if(Std.is(value, Int))
      return Promise.value(value);

    if(Std.is(value, Bool))
      return Promise.value(true ? 1 : 0);

    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" is not a type that can be converted to a Int'));

    if(Ints.canParse(value))
      return Promise.value(Ints.parse(value));
    else
      return Promise.error(new Error('"$value" is not an Integer value'));
  }
}
