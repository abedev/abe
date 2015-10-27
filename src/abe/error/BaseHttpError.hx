package abe.error;

class BaseHttpError extends express.Error {
  public function new(msg : String, statusCode : Int) {
    super(msg);
    this.status = statusCode;
  }
}
