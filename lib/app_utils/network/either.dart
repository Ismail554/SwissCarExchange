class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool isLeft;

  Either._(this._left, this._right, this.isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R value) => Either._(null, value, false);

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) =>
      isLeft ? onLeft(_left as L) : onRight(_right as R);
}

Either<L, R> left<L, R>(L value) => Either.left(value);
Either<L, R> right<L, R>(R value) => Either.right(value);

typedef E<T> = Future<Either<String, T>>;