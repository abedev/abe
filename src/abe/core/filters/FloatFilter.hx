package abe.core.filters;

import thx.core.Floats;
import thx.core.Error;
import thx.promise.Promise;

class FloatFilter implements IFilterArgument<Float> {
  public function new(){}

  public var type = "Float";
  public function filter(value : String) : Promise<Float> {
    if(Floats.canParse(value))
      return Promise.value(Floats.parse(value));
    else
      return Promise.error(new Error('"$value" is not a Float value'));
  }
}
