package abe.core.filters;

import thx.Floats;
import thx.Error;
import thx.promise.Promise;
using thx.DateTimeUtc;

class DateFilter implements IFilterArgument<Date> {
  static var TIME_PATTERN = ~/^\d+$/;
  public function new(){}

  public var type = "Date";
  public function filter(value : Dynamic) : Promise<Date> {
    if(Std.is(value, Float))
      return Promise.value(Date.fromTime(value));

    if(!Std.is(value, String))
      return Promise.error(new Error('"$value" is not a type that can be converted to a Date'));

    try {
      // try first to parse as a string that datetimeutc understands
      // e.g. 2016-08-07T23:18:22.123Z
      return Promise.value(DateTimeUtc.fromString(value).toDate());

    } catch(e : Dynamic) {
      // fall back to parsing as float buried inside a string
      if(TIME_PATTERN.match(value))
        return Promise.value(Date.fromTime(Floats.parse(value)));

      try {
        return Promise.value(Date.fromString(value));
      } catch(e : Dynamic) {
        return Promise.error(new Error('"$value" is not a Date value'));
      }
    }
  }
}
