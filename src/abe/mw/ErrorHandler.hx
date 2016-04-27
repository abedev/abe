package abe.mw;

import abe.error.BaseHttpError;
import express.Middleware;
import express.Next;
import express.Request;
import express.Response;
import js.Error;
using thx.Strings;

class ErrorHandler {
  public static function handle(?format : ErrorFormat) : ErrorMiddleware {
    if(null == format)
      format = TextError;
    return function(err : Error, request : Request, response : Response, next : Next) {
      var httpError : BaseHttpError = Std.is(err, BaseHttpError) ? cast err : null;

      // if we have an error we can understand, just do the right thing
      if (httpError != null) sendError(httpError.status, httpError, response, format);

      // otherwise, check the name and message for common terms
      else if (err.name.toLowerCase().startsWith("unauthorized")) sendError(401, err, response, format);
      else if (err.message.toLowerCase().startsWith("cannot validate")) sendError(400, err, response, format);

      // and finally, fall back to a good old fashioned 500 error
      else sendError(500, err, response, format);
    };
  }

  static function sendError(status, err : Error, response : Response, format : ErrorFormat) {
    response.status(status);

    switch format {
      case TextError:
        response.send(err.message);
      case JsonError:
        // send the full error object to the client
        response.send(err);
      case JsonMessage:
        response.send({ message : err.message });
    }
  }
}

enum ErrorFormat {
  TextError;
  JsonError;
  JsonMessage;
}
