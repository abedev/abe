package restx.core;

enum ArgumentProcessing<T : {}> {
  Ok(args : Array<Dynamic>);
  InvalidType(msg : String);
  Required(msg : String);
}