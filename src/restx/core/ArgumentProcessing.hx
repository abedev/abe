package restx.core;

enum ArgumentProcessing<T : {}> {
  Ok(args : T);
  InvalidType(msg : String);
  Required(msg : String);
}