package abe;

import express.Next;
import express.Request;
import express.Response;

@:autoBuild(abe.core.macros.BuildIRoute.complete())
interface IRoute {
  public var request : Request;
  public var response : Response;
  public var next : Next;
}