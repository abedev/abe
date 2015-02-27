package abe;

import thx.promise.Promise;

interface IFilterArgument<T> {
  public var type : String;

  function filter(value : Dynamic) : Promise<T>;
}
