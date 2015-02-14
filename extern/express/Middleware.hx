package express;

typedef FMiddlware = Response -> Request -> Void;
typedef FMiddlwareNext = Response -> Request -> Next -> Void;

abstract Middleware(Dynamic)
  from FMiddlware to FMiddlware
  from FMiddlwareNext to FMiddlwareNext
{ }