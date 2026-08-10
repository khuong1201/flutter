abstract class Failure {
  final String messageKey;
  Failure(this.messageKey);
}

class ServerFailure extends Failure {
  ServerFailure([super.messageKey = 'errorServer']);
}

class CacheFailure extends Failure {
  CacheFailure([super.messageKey = 'errorCache']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.messageKey = 'errorNetwork']);
}

class UnknownFailure extends Failure {
  UnknownFailure([super.messageKey = 'errorUnknown']);
}

class InvalidCredentialsFailure extends Failure {
  InvalidCredentialsFailure([super.messageKey = 'errorInvalidCredentials']);
}

class UserExistsFailure extends Failure {
  UserExistsFailure([super.messageKey = 'errorUserExists']);
}

class BadRequestFailure extends Failure {
  BadRequestFailure([super.messageKey = 'errorBadRequest']);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure([super.messageKey = 'errorUnauthorized']);
}
