import 'package:equatable/equatable.dart';

sealed class AsyncValue<T> {
  const AsyncValue._();

  const factory AsyncValue.loading() = AsyncLoading<T>;
  const factory AsyncValue.data(T value) = AsyncData;
  const factory AsyncValue.error(Object error, [StackTrace? stackTrace]) = AsyncError<T>;

  static Future<AsyncValue<T>> guard<T>(Future<T> Function() future, [bool Function(Object)? test]) async {
    try {
      return AsyncValue.data(await future());
    } catch (err, stack) {
      if (test == null) {
        return AsyncValue.error(err, stack);
      }
      if (test(err)) {
        return AsyncValue.error(err, stack);
      }

      Error.throwWithStackTrace(err, stack);
    }
  }

  bool get hasData;

  bool get hasError;

  bool get isLoading;

  R map<R>({
    required R Function() orElse,
    R Function(AsyncLoading<T> value)? loading,
    R Function(AsyncData<T> value)? data,
    R Function(AsyncError<T> value)? error,
  });
}

final class AsyncLoading<T> extends AsyncValue<T> with EquatableMixin {
  const AsyncLoading() : super._();

  @override
  List<Object?> get props => [];

  @override
  bool get hasData => false;

  @override
  bool get hasError => false;

  @override
  bool get isLoading => true;

  @override
  R map<R>({
    required R Function() orElse,
    R Function(AsyncLoading<T> value)? loading,
    R Function(AsyncData<T> value)? data,
    R Function(AsyncError<T> value)? error,
  }) {
    return loading?.call(this) ?? orElse();
  }
}

final class AsyncData<T> extends AsyncValue<T> with EquatableMixin {
  const AsyncData(this.value) : super._();

  final T value;

  @override
  bool get hasData => true;

  @override
  bool get hasError => false;

  @override
  bool get isLoading => false;

  @override
  R map<R>({
    required R Function() orElse,
    R Function(AsyncLoading<T> value)? loading,
    R Function(AsyncData<T> value)? data,
    R Function(AsyncError<T> value)? error,
  }) {
    return data?.call(this) ?? orElse();
  }

  @override
  List<Object?> get props => [value];
}

final class AsyncError<T> extends AsyncValue<T> with EquatableMixin {
  const AsyncError(this.error, [this.stackTrace]) : super._();

  final Object error;
  final StackTrace? stackTrace;

  @override
  bool get hasData => false;

  @override
  bool get hasError => true;

  @override
  bool get isLoading => false;

  @override
  R map<R>({
    required R Function() orElse,
    R Function(AsyncLoading<T> value)? loading,
    R Function(AsyncData<T> value)? data,
    R Function(AsyncError<T> value)? error,
  }) {
    return error?.call(this) ?? orElse();
  }

  @override
  List<Object?> get props => [error];
}

extension AsyncExt<T> on AsyncValue<T> {
  R? whenData<R>(R Function(T value) fn) {
    return map(data: (state) => fn(state.value), orElse: () => null);
  }
}
