import 'package:dio/dio.dart';

sealed class Failure {
  final String message;

  const Failure(this.message);

  factory Failure.fromException(Object? error) {
    if (error is DioException) {
      if (error.response?.statusCode == 500) {
        return ServerFailure();
      } else if (error.type == DioExceptionType.cancel) {
        return ResponseFailure(error.message ?? 'Request was cancelled');
      } else {
        return ResponseFailure(
          error.message ?? 'An error occurred while processing the request',
        );
      }
    } else if (error is ResponseFailure) {
      return ResponseFailure(error.message);
    }
    return UnknownFailure();
  }

  @override
  String toString() => 'Failure: $message';
}

class ServerFailure extends Failure {
  const ServerFailure() : super('Server error occurred');
}

class ResponseFailure extends Failure {
  const ResponseFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('An unknown error occurred');
}
