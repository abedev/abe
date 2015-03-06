package routes;

import utest.Assert;

@:path("/validate/")
class Validate implements abe.IRoute {
  @:get("/:id")
  @:validate(function (id : Int, req : express.Request, res : express.Response, next : express.Next) {
      if (id == 9) (next : Void -> Void)();
      else res.sendStatus(400);
    })
  function getById(id : Int) {
    response.send('$id');
  }
}
