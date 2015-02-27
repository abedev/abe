package abe.core.filters;

import thx.core.Floats;
import thx.core.Error;
import thx.promise.Promise;

class FloatFilter implements IFilterArgument<Float> {
  public function new(){}

  public var type = "Float";
  public function filter(value : Dynamic) : Promise<Float> {
    if(Std.is(value, Float))
      return Promise.value(value);

    if(Std.is(value, Bool))
      return Promise.value(true ? 1.0 : 0.0);

    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" is not a type that can be converted to a Float'));

    if(Floats.canParse(value))
      return Promise.value(Floats.parse(value));
    else
      return Promise.error(new Error('"$value" is not a Float value'));
  }
}
