package restx;

import express.Next;
import express.Request;
import express.Response;

class RouteProcess<TRoute : IRoute> {
  public function new() { }
  public function run(req : Request, res : Response, next : Next) : Void {}
}