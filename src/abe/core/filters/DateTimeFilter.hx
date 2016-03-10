package abe.core.filters;

import thx.Error;
import thx.DateTime;
import thx.promise.Promise;

class DateTimeFilter implements IFilterArgument<DateTime> {
  public function new(){}

  public var type = "DateTime";
  public function filter(value : Dynamic) : Promise<DateTime> {
    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" must be a string to be parsed as DateTime'));

    try {
      return Promise.value(DateTime.fromString(value));
    } catch (e : Dynamic) {
      return Promise.error(new Error('"$value" could not be parsed as a DateTime'));
    }
  }
}
