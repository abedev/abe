package abe.error;

class GatewayTimeoutError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Gateway Timeout";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 504, pos);
  }
}
