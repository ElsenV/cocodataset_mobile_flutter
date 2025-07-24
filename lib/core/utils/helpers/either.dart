abstract class Either<L, R> {
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight);

  bool get isLeft;
  bool get isRight;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  Left(this.value);

  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifLeft(value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;
}

class Right<L, R> extends Either<L, R> {
  final R value;
  Right(this.value);
  @override
  T fold<T>(T Function(L l) ifLeft, T Function(R r) ifRight) => ifRight(value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;
}
