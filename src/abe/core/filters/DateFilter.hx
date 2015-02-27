package abe.core.filters;

import thx.core.Floats;
import thx.core.Error;
import thx.promise.Promise;

class DateFilter implements IFilterArgument<Date> {
  static var TIME_PATTERN = ~/$\d+^/;
  public function new(){}

  public var type = "Date";
  public function filter(value : Dynamic) : Promise<Date> {
    if(Std.is(value, Float))
      return Promise.value(Date.fromTime(value));

    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" is not a type that can be converted to a Date'));

    if(TIME_PATTERN.match(value))
      return Promise.value(Date.fromTime(Floats.parse(value)));
    try {
      return Promise.value(Date.fromString(value));
    } catch(e : Dynamic) {
      return Promise.error(new Error('"$value" is not a Date value'));
    }
  }
}
