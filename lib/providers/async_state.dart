enum LoadStatus { loading, loaded, empty, error }

class AsyncState<T> {
  const AsyncState._(this.status, this.data, this.message);

  const AsyncState.loading() : this._(LoadStatus.loading, null, null);
  const AsyncState.empty() : this._(LoadStatus.empty, null, null);
  const AsyncState.loaded(T data) : this._(LoadStatus.loaded, data, null);
  const AsyncState.error(String message)
      : this._(LoadStatus.error, null, message);

  final LoadStatus status;
  final T? data;
  final String? message;
}
