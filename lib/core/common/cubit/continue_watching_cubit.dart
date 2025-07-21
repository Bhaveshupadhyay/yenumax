import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/failure.dart';
import '../../service/network_api.dart';
import '../model/continue_watching_model.dart';


class ContinueWatchingCubit extends Cubit<ContinueWatchingState>{

  ContinueWatchingCubit():super(ContinueWatchingInitial());

  Future<void> addToContinueWatching({required int contentId, required int contentType}) async {
    if(state is ContinueWatchingContentUpdating) return;

    emit(ContinueWatchingContentUpdating());
    // final res= await DioApi().addToContinueWatching(contentId: contentId, contentType: contentType);
    // if(isClosed) return;
    //
    // res.fold(
    //         (failure){
    //       emit(ContinueWatchingUpdateFailed(failure: Failure(msg: failure.msg)));
    //     },
    //         (isAddedToContinueWatching){
    //       emit(ContinueWatchingContentUpdated(isAddedToContinueWatching: isAddedToContinueWatching));
    //     }
    // );
  }

  Future<void> loadContinueWatching() async {

    emit(ContinueWatchingLoading());
    final res= await DioApi().getContinueWatching();
    if(isClosed) return;

    res.fold(
            (failure){
          emit(ContinueWatchingFailed(failure: Failure(msg: failure.msg)));
        },
            (data){
          emit(ContinueWatchingLoaded(data: data));
        }
    );
  }
}

sealed class ContinueWatchingState{}

final class ContinueWatchingInitial extends ContinueWatchingState{}
final class ContinueWatchingLoading extends ContinueWatchingState{}

final class ContinueWatchingLoaded extends ContinueWatchingState{
  final List<ContinueWatchingModel> data;
  final bool isLoadingMore;
  final bool hasReachedMax;

  ContinueWatchingLoaded({required this.data,this.isLoadingMore=false,this.hasReachedMax=false,});
}

final class ContinueWatchingFailed extends ContinueWatchingState{
  final Failure failure;

  ContinueWatchingFailed({required this.failure});
}

///Failed to Load more data
final class ContinueWatchingMoreFailed<T> extends ContinueWatchingState{
  final T oldData;
  final Failure failure;

  ContinueWatchingMoreFailed({required this.failure,required this.oldData,});
}

final class ContinueWatchingContentUpdating extends ContinueWatchingState{}
final class ContinueWatchingContentUpdated extends ContinueWatchingState{
  final bool isAddedToContinueWatching;

  ContinueWatchingContentUpdated({required this.isAddedToContinueWatching});
}

final class ContinueWatchingUpdateFailed extends ContinueWatchingState{
  final Failure failure;

  ContinueWatchingUpdateFailed({required this.failure});
}