package abe.mw;

import abe.error.BaseHttpError;
import express.Middleware;
import express.Next;
import express.Request;
import express.Response;
import js.Error;
using thx.Strings;

class ErrorHandler {
  public static function handle(?debug = false) : ErrorMiddleware {
    return function(err : Error, request : Request, response : Response, next : Next) {
      var httpError : BaseHttpError = Std.is(err, BaseHttpError) ? cast err : null;

      // if we have an error we can understand, just do the right thing
      if (httpError != null) sendError(httpError.status, httpError, response, debug);

      // otherwise, check the name and message for common terms
      else if (err.name.toLowerCase().startsWith("unauthorized")) sendError(401, err, response, debug);
      else if (err.message.toLowerCase().startsWith("cannot validate")) sendError(400, err, response, debug);

      // and finally, fall back to a good old fashioned 500 error
      else sendError(500, err, response, debug);
    };
  }

  static function sendError(status, err : Error, response : Response, debug : Bool) {
    response.status(status);

    // conditionally send/log err.stack
    if (debug) {
      // trace('ABE SENDING ERROR STATUS: $status');
      // if (err.stack != null) {
      //   trace(err.stack);
      // }

      // send the full error object to the client
      response.send(err);
      return;
    }

    // no debug, so just send the message
    response.send({ message : err.message });
  }
}
