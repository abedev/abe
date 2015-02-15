package routes;

import utest.Assert;

import express.Next;
import express.Request;
import express.Response;
import restx.IRoute;

class Auto implements IRoute {
  public var request : Request;
  public var response : Response;
  public var next : Next;
  public function new() {}
}