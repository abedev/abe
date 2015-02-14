package express;

typedef FNext = Void -> Void;
typedef FNextRoute = String -> Void;

abstract Next(Dynamic)
  from FNext to FNext
  from FNextRoute to FNextRoute
{ }