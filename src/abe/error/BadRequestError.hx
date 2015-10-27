package abe.error;

class BadRequestError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Bad Request";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 400, pos);
  }
}
