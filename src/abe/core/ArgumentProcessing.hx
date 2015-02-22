package abe.core;

import thx.core.Error;

enum ArgumentProcessing {
  Ok;
  InvalidFilter(err : Error);
  Required(parameter : String);
}
