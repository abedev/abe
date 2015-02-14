package restx.core;

enum ArgumentProcessing {
  Ok;
  InvalidType(msg : String);
  Required(msg : String);
}