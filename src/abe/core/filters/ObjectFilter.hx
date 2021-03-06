package abe.core.filters;

import haxe.Json;
import thx.Objects;
import thx.Error;
import thx.promise.Promise;

class ObjectFilter implements IFilterArgument<{}> {
  public function new(){}

  public var type = "{}";
  public function filter(value : Dynamic) : Promise<{}> {
    if(Reflect.isObject(value))
      return Promise.value(value);
    if(Std.is(value, String)) {
      var v = try Json.parse(value) catch(e : Dynamic) null;
      if(null != v)
        return Promise.value(v);
      v = try thx.QueryString.parse(value).toObject() catch(e : Dynamic) null;
      if(null != v)
        return Promise.value(v);
      return Promise.error(new Error('"$value" cannot be transformed to an Object value'));
    }
    return Promise.error(new Error('"$value" is not an Object value'));
  }
}
