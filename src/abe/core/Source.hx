package abe.core;

@:enum
abstract Source(String) from String to String {
  var Params = "params";
  var Query = "query";
  var Body = "body";
  var Request = "request";
}
