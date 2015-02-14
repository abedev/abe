package restx;

import express.Next;
import express.Request;
import express.Response;

interface IRoute {
  public var request : Request;
  public var response : Response;
  public var next : Next;
}