package abe.core;

import thx.Error;

enum ArgumentProcessing {
  Ok;
  InvalidFilter(err : Error);
  Required(parameter : String);
}
