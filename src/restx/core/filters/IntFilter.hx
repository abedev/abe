package restx.core.filters;

import thx.core.Either;
import thx.core.Ints;
import thx.core.Result;

class IntFilter implements IFilterArgument<Int> {
  public function new(){}

  public var type = "Int";
  public function filter(value : String) : Result<Int, String> {
    if(Ints.canParse(value))
      return Either.Right(Ints.parse(value));
    else
      return Either.Left('"$value" is not an Integer value');
  }
}