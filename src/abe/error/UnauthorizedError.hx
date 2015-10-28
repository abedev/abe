package abe.error;

class UnauthorizedError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Unauthorized";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 401, pos);
  }
}
