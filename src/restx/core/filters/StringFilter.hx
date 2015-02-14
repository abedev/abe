package restx.core.filters;

import thx.core.Either;
import thx.core.Result;

class StringFilter implements IFilterArgument<String> {
  public function new(){}

  public var type = "String";
  public function filter(value : String) : Result<String, String>
    return Either.Right(value);
}