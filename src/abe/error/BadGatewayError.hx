package abe.error;

class BadGatewayError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Bad Gateway";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 502, pos);
  }
}
