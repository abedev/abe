package abe.error;

class ForbiddenError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Forbidden";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 403, pos);
  }
}
