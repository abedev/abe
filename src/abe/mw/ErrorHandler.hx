package abe.mw;

import abe.error.BaseHttpError;
import js.Error;
using thx.Strings;

class ErrorHandler {
  public static var handle(default, null) : ErrorMiddleware;

  handle = function(err : Error, request : Request, response : Response, next : Next) {
    var httpError : BaseHttpError = Std.is(err, BaseHttpError) ? cast err : null;

    // if we have an error we can understand, just do the right thing
    if (httpError != null) sendError(httpError.statusCode, httpError, response);

    // otherwise, check the name and message for common terms
    else if (err.name.toLowerCase().startsWith("unauthorized")) sendError(401, err, response);
    else if (err.message.toLowerCase().startsWith("cannot validate")) sendError(400, err, response);

    // and finally, fall back to a good old fashioned 500 error
    else sendError(500, err, response);
  }

  static function sendError(status, err : Error, response : Response) {
    // TODO: configure this with a Bool `debug` flag and conditionally send/log err.stack
    response.status(status);
    response.send(err.message);
  }
}
