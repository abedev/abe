package express;

import js.Error;

typedef FNext = Void -> Void;
typedef FNextRoute = String -> Void;
typedef FNextError = Error -> Void;

abstract Next(Dynamic)
  from FNext to FNext
  from FNextRoute to FNextRoute
  from FNextError to FNextError
{ }