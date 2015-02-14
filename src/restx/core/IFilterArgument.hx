package restx.core;

import thx.core.Result;

interface IFilterArgument<T> {
  public var type : String;

  function filter(value : String) : Result<T, String>;
}