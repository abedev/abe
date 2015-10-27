package abe.error;

class BaseHttpError extends thx.Error {
  public var statusCode : Int;
  public function new(msg : String, statusCode : Int) {
    super(msg);
    this.statusCode = statusCode;
  }
}
