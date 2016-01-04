package abe.error;

class InternalServerError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Internal Server Error";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 500, pos);
  }
}
