import '../../service/failure.dart';

sealed class DataState{}

final class DataInitial extends DataState{}
final class DataLoading extends DataState{}

final class DataLoaded<T> extends DataState{
  final T data;
  final bool isLoadingMore;
  final bool hasReachedMax;

  DataLoaded({required this.data,this.isLoadingMore=false,this.hasReachedMax=false,});

  DataLoaded<T> copyWith({
    T? data,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return DataLoaded(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class DataFailed extends DataState{
  final Failure failure;

  DataFailed({required this.failure});
}

///Failed to Load more data
final class DataMoreFailed<T> extends DataState{
  final T oldData;
  final Failure failure;

  DataMoreFailed({required this.failure,required this.oldData,});
}

