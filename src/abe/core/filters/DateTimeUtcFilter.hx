package abe.core.filters;

import thx.Error;
import thx.DateTimeUtc;
import thx.promise.Promise;

class DateTimeUtcFilter implements IFilterArgument<DateTimeUtc> {
  public function new(){}

  public var type = "thx.DateTimeUtc";
  public function filter(value : Dynamic) : Promise<DateTimeUtc> {
    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" must be a string to be parsed as DateTimeUtc'));

    try {
      return Promise.value(DateTimeUtc.fromString(value));
    } catch (e : Dynamic) {
      return Promise.error(new Error('"$value" could not be parsed as a DateTimeUtc'));
    }
  }
}
