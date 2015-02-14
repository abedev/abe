package restx.core;

import thx.core.Result;
import thx.promise.Promise;

interface IFilterArgument<T> {
  public var type : String;

  function filter(value : String) : Promise<T>;
}