package restx.core;

enum ArgumentProcessing {
  Ok;
  InvalidFilter(msg : String);
  Required(parameter : String);
}