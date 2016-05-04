package abe.core.filters;

import thx.promise.Promise;
import thx.Error;

class ArrayFilter<T> implements IFilterArgument<Array<T>> {
  var delimiter : String;
  var subFilter : IFilterArgument<T>;
  var subType : String;
  public var type : String;
  public function new(subtype : String, delimiter : String, subfilter : IFilterArgument<T>) {
    this.subType = subtype;
    this.type = 'Array<$subtype>';
    this.delimiter = delimiter;
    this.subFilter = subfilter;
  }

  public function filter(value : Dynamic) : Promise<Array<T>> {
    if(Std.is(value, Array)) {
      var values : Array<Dynamic> = value;
      return Promise.sequence(values.map(subFilter.filter));
    } else if(Std.is(value, String) && null != delimiter) {
      return Promise.sequence((value : String).split(delimiter).map(subFilter.filter));
    } else {
      return Promise.error(new Error('"$value" is not an Array of $subType'));
    }
  }
}
