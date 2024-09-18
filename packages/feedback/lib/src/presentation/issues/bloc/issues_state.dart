part of 'issues_bloc.dart';

typedef FeedbacksState = AsyncValue<List<FeedbackEvent>>;

sealed class AsyncValue<T> {
  const AsyncValue._();

  const factory AsyncValue.loading() = AsyncLoading<T>;
  const factory AsyncValue.data(T value) = AsyncData;
  const factory AsyncValue.error(Object error, [StackTrace? stackTrace]) = AsyncError<T>;

  bool get hasData;

  bool get hasError;

  bool get isLoading;
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
}

final class AsyncData<T> extends AsyncValue<T> with EquatableMixin {
  const AsyncData(this.value) : super._();

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  bool get hasData => true;

  @override
  bool get hasError => false;

  @override
  bool get isLoading => false;
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
  List<Object?> get props => [error];
}
