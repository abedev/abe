package express;

@:jsRequire("express")
extern class Express implements Dynamic {
  @:selfCall function new(?options : Dynamic) : Void;

  var locals(default, null) : Dynamic;
  var mountpath(default, null) : Array<String>;

  @:overload(function(subApp : Express) : Express {})
  function use() : Express;
}