package abe;

@:enum abstract Method(String) from String to String {
  var All = "all";
  var Checkout = "checkout";
  var Connect = "connect";
  var Copy = "copy";
  var Delete = "delete";
  var Get = "get";
  var Head = "head";
  var Lock = "lock";
  var Merge = "merge";
  var MkActivity = "mkactivity";
  var MkCol = "mkcol";
  var Move = "move";
  var MSearch = "m-search";
  var Notify = "notify";
  var Options = "options";
  var Patch = "patch";
  var Post = "post";
  var PropFind = "propfind";
  var PropPatch = "proppatch";
  var Purge = "purge";
  var Put = "put";
  var Report = "report";
  var Search = "search";
  var Subscribe = "subscribe";
  var Trace = "trace";
  var Unlock = "unlock";
  var Unsubscribe = "unsubscribe";
}
