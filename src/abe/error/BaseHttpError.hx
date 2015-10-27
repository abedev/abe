package abe.error;

class BaseHttpError extends thx.Error {
  public var status(default, null) : Int;
  public function new(msg : String, status : Int, ?pos : haxe.PosInfos) {
    super(msg, pos);
    this.status = status;
  }
}
