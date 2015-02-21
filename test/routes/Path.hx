package routes;

import utest.Assert;

@:path("/some/prefix/")
class Path implements restx.IRoute {
  @:get("/")
  function index() {
    response.send('INDEX');
  }

  @:get("/list/")
  function list() {
    response.send('LIST');
  }
}