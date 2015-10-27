package abe.error;

class NotFoundError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Not Found";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 404, pos);
  }
}
