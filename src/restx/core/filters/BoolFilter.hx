package restx.core.filters;

import thx.core.Either;
import thx.core.Bools;
import thx.core.Result;

class BoolFilter implements IFilterArgument<Bool> {
  public function new(){}

  public var type = "Bool";
  public function filter(value : String) : Result<Bool, String> {
    if(Bools.canParse(value))
      return Either.Right(Bools.parse(value));
    else
      return Either.Left('"$value" is not an Booleger value');
  }
}