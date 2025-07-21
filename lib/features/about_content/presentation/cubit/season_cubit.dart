import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/core/service/network_api.dart';

class SeasonCubit extends Cubit<SeasonState>{

  SeasonCubit():super(SeasonInitial());

  Future<void> getTotalSeasons({required int contentId}) async {
    emit(SeasonLoading());
    final res= await DioApi().getSeasonsCount(contentId: contentId);
    if(isClosed) return;
    res.fold(
            (failure){
              emit(SeasonFailed(failure: Failure(msg: failure.msg)));
            },
            (seasonCount){
              emit(SeasonLoaded(totalSeasons: seasonCount, currentSeason: seasonCount>0? 1: 0));
            }
    );
  }
}

sealed class SeasonState{}

final class SeasonInitial extends SeasonState{}
final class SeasonLoading extends SeasonState{}
final class SeasonLoaded extends SeasonState{
  final int totalSeasons;
  final int currentSeason;

  SeasonLoaded({required this.totalSeasons, required this.currentSeason});
}
final class SeasonFailed extends SeasonState{
  final Failure failure;

  SeasonFailed({required this.failure});
}