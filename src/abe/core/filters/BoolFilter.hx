package abe.core.filters;

import thx.core.Bools;
import thx.core.Error;
import thx.promise.Promise;

class BoolFilter implements IFilterArgument<Bool> {
  public function new(){}

  public var type = "Bool";
  public function filter(value : String) : Promise<Bool> {
    if(Bools.canParse(value))
      return Promise.value(Bools.parse(value));
    else
      return Promise.error(new Error('"$value" is not a Boolean value'));
  }
}
