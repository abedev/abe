package restx;

@:enum abstract Method(String) from String to String {
  var All = "all";
  var Get = "get";
  var Post = "post";
  var Head = "head";
  var Options = "options";
  var Put = "put";
  var Delete = "delete";
  var Trace = "trace";
  var Connect = "connect";
}
