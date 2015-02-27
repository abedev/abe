package abe.core.filters;

import thx.core.Bools;
import thx.core.Error;
import thx.promise.Promise;

class BoolFilter implements IFilterArgument<Bool> {
  public function new(){}

  public var type = "Bool";
  public function filter(value : Dynamic) : Promise<Bool> {
    if(Std.is(value, Bool))
      return Promise.value(value);
    if(Std.is(value, Int))
      return Promise.value(value != 0);

    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" is not a type that can be converted to a Bool'));

    if(Bools.canParse(value))
      return Promise.value(Bools.parse(value));
    else
      return Promise.error(new Error('"$value" is not a Boolean value'));
  }
}
