package restx.core;

enum ArgumentProcessing {
  Ok(args : Array<Dynamic>);
  InvalidType(msg : String);
  Required(msg : String);
}