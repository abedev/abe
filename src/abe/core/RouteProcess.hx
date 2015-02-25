package abe.core;

import express.Next;
import express.Request;
import express.Response;
import js.Error;
import abe.core.ArgumentProcessor;

class RouteProcess<TRoute : IRoute, TArgs : {}> {
  var instance : TRoute;
  var argumentProcessor : ArgumentProcessor<TArgs>;
  var args : TArgs;
  public function new(args : TArgs, instance : TRoute, argumentProcessor : ArgumentProcessor<TArgs>) {
    this.instance = instance;
    this.argumentProcessor = argumentProcessor;
    this.args = args;
  }

  public function run(req : Request, res : Response, next : Next) {
    argumentProcessor.processArguments(req, args).then(function(result) {
      switch result {
        case Ok:
          instance.request = req;
          instance.response = res;
          instance.next = next;
          execute();
        case Required(_), InvalidFilter(_):
          (next : Void -> Void)();
      }
    });

  }

  function execute()
    throw 'RouteProcess.execute() must be overwritten';
}
