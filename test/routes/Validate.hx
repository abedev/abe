package routes;

import express.Request;
import express.Response;
import express.Next;
import utest.Assert;

@:path("/validate/")
class Validate implements abe.IRoute {
  @:get("/:id")
  @:validate(function (id : Int, req : Request, res : Response, next : Next) {
      if (id == 9) next();
      else res.sendStatus(400);
    })
  function getById(id : Int) {
    response.send('$id');
  }
}
