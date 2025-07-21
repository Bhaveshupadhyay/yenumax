import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/model/watchlist_model.dart';

import '../../service/failure.dart';
import '../../service/network_api.dart';

class WatchlistCubit extends Cubit<WatchListState>{
  WatchlistCubit():super(WatchListInitial());


  Future<void> addToWatchList({required int contentId, required int contentType}) async {
    if(state is WatchListContentUpdating) return;

    emit(WatchListContentUpdating());
    final res= await DioApi().addToWatchList(contentId: contentId, contentType: contentType);
    if(isClosed) return;

    res.fold(
            (failure){
          emit(WatchListUpdateFailed(failure: Failure(msg: failure.msg)));
        },
            (isAddedToWatchList){
              emit(WatchListContentUpdated(isAddedToWatchList: isAddedToWatchList));
            }
    );
  }

  Future<void> loadWatchList() async {

    emit(WatchListLoading());
    final res= await DioApi().getWatchlist();
    if(isClosed) return;

    res.fold(
            (failure){
          emit(WatchListFailed(failure: Failure(msg: failure.msg)));
        },
            (data){
              emit(WatchListLoaded(data: data));
            }
    );
  }
}

sealed class WatchListState{}

final class WatchListInitial extends WatchListState{}
final class WatchListLoading extends WatchListState{}

final class WatchListLoaded extends WatchListState{
  final List<WatchlistModel> data;
  final bool isLoadingMore;
  final bool hasReachedMax;

  WatchListLoaded({required this.data,this.isLoadingMore=false,this.hasReachedMax=false,});
}

final class WatchListFailed extends WatchListState{
  final Failure failure;

  WatchListFailed({required this.failure});
}

///Failed to Load more data
final class WatchListMoreFailed<T> extends WatchListState{
  final T oldData;
  final Failure failure;

  WatchListMoreFailed({required this.failure,required this.oldData,});
}

final class WatchListContentUpdating extends WatchListState{}
final class WatchListContentUpdated extends WatchListState{
  final bool isAddedToWatchList;

  WatchListContentUpdated({required this.isAddedToWatchList});
}

final class WatchListUpdateFailed extends WatchListState{
  final Failure failure;

  WatchListUpdateFailed({required this.failure});
}