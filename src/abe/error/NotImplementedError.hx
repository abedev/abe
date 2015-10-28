package abe.error;

class NotImplementedError extends BaseHttpError {
  static var DEFAULT_MESSAGE = "Not Implemented";
  public function new(?msg : String, ?pos : haxe.PosInfos) {
    super(msg == null ? DEFAULT_MESSAGE : msg, 501, pos);
  }
}
