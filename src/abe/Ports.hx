package abe;

import thx.promise.Promise;
import thx.Nil;

class Ports {
  public static function ifAvailable(port : Int, ?host : String) : Promise<Nil> {
    if(null == host)
      host = "localhost";
    return Promise.create(function(resolve, reject) {
      var client = new js.node.net.Socket();

      function cleanup() { // TODO is this really needed?
        client.removeAllListeners("connect");
        client.removeAllListeners("error");
        client.end();
        client.destroy();
        client.unref();
      }

      client.once("connect", function() {
        cleanup();
        reject(new thx.Error('Port $port on $host is unavailable'));
      });
      client.once("error", function(e) {
        cleanup();
        if(e.code == "ECONNREFUSED" || e.code == "ENOTFOUND")
          resolve(Nil.nil);
        else
          reject(thx.Error.fromDynamic(e));
      });
      client.connect({ port : port, host : host });
    });
  }
}
