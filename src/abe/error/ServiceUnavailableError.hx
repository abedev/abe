package abe.error;

class ServiceUnavailableError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Service Unavailable";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 503, pos);
  }
}
