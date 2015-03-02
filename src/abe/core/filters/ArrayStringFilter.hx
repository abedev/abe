package abe.core.filters;

import thx.promise.Promise;
import thx.core.Error;

class ArrayStringFilter implements IFilterArgument<Array<String>> {
  public function new(){}

  public var type = "Array<String>";
  public function filter(value : Dynamic) : Promise<Array<String>> {
    if(Std.is(value, Array))
      return Promise.value(value);
    else
      return Promise.error(new Error('"$value" is not an Array of Strings'));
  }
}
