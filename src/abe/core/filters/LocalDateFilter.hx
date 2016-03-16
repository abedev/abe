package abe.core.filters;

import thx.Error;
import thx.LocalDate;
import thx.promise.Promise;

class LocalDateFilter implements IFilterArgument<LocalDate> {
  public function new(){}

  public var type = "thx.LocalDate";
  public function filter(value : Dynamic) : Promise<LocalDate> {
    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" must be a string to be parsed as LocalDate'));

    try {
      return Promise.value(LocalDate.fromString(value));
    } catch (e : Dynamic) {
      return Promise.error(new Error('"$value" could not be parsed as a LocalDate'));
    }
  }
}
