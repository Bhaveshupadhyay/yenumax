import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/features/about_content/model/episode_model.dart';

// class EpisodesCubit extends Cubit<DataState>{
//
//   int _pageNumber=1;
//   final List<EpisodeModel> _episodes=[];
//
//   EpisodesCubit():super(DataInitial());
//
//   Future<void> getEpisodes({required int contentId,required int seasonNumber,}) async {
//     if(state is DataLoading ||
//         (state is DataLoaded<List<EpisodeModel>> &&
//             ((state as DataLoaded<List<EpisodeModel>>).isLoadingMore || (state as DataLoaded<List<EpisodeModel>>).hasReachedMax))) {
//       return;
//     }
//
//     final bool isFirstLoad = state is DataInitial;
//
//     if (isFirstLoad) {
//       emit(DataLoading());
//     }
//     else if (state is DataLoaded<List<EpisodeModel>>) {
//       emit((state as DataLoaded<List<EpisodeModel>>).copyWith(isLoadingMore: true));
//     }
//
//     final res= await DioApi().getSeasonEpisodes(contentId: contentId, seasonNumber: seasonNumber, pageItems: 5, pageNumber: _pageNumber);
//     if(isClosed) return;
//     res.fold(
//             (failure){
//               emit(DataFailed(failure: Failure(msg: failure.msg)));
//               },
//
//             (episodes){
//               _pageNumber++;
//               _episodes.addAll(episodes);
//
//               emit(DataLoaded<List<EpisodeModel>>(data: _episodes,isLoadingMore: false,hasReachedMax: episodes.isEmpty));
//             }
//     );
//   }
// }

//
// class EpisodesCubit extends Cubit<EpisodesState>{
//
//   int _pageNumber=1;
//   final int _pageLimit=5;
//   final Map<int, EpisodesData> map={};
//
//   EpisodesCubit():super(EpisodeInitial());
//
//   Future<void> getEpisodes({required int contentId,required int seasonNumber,}) async {
//     if(state is DataLoading ||
//         (state is DataLoaded<List<EpisodeModel>> &&
//             ((state as DataLoaded<List<EpisodeModel>>).isLoadingMore || (state as DataLoaded<List<EpisodeModel>>).hasReachedMax))) {
//       return;
//     }
//
//     final bool isFirstLoad = state is DataInitial;
//
//     if (isFirstLoad) {
//       emit(DataLoading());
//     }
//     else if (state is DataLoaded<List<EpisodeModel>>) {
//       emit((state as DataLoaded<List<EpisodeModel>>).copyWith(isLoadingMore: true));
//     }
//     final loadedEpisodes= map[seasonNumber];
//
//     final res= await DioApi().getSeasonEpisodes(contentId: contentId, seasonNumber: seasonNumber, pageItems: _pageLimit,
//         pageNumber: loadedEpisodes!=null? loadedEpisodes.pageNumber:1);
//     if(isClosed) return;
//     res.fold(
//             (failure){
//           emit(DataFailed(failure: Failure(msg: failure.msg)));
//         },
//
//             (episodes){
//           _pageNumber++;
//           if(loadedEpisodes!=null){
//             loadedEpisodes.previousLoadedEpisodes.addAll(episodes);
//             loadedEpisodes.pageNumber++;
//           }
//           else{
//             map[seasonNumber]= EpisodesData(previousLoadedEpisodes: episodes,hasReachedMax: episodes.isEmpty,pageNumber: 1);
//           }
//
//           emit(DataLoaded<List<EpisodeModel>>(data: map[seasonNumber]?.previousLoadedEpisodes??[],isLoadingMore: false,hasReachedMax: episodes.isEmpty));
//         }
//     );
//   }
// }

class EpisodesCubit extends Cubit<DataState>{

  int _pageNumber=1;
  final Map<int,DataState> _state= {};
  final Map<int,EpisodesData> _episodes= {};

  EpisodesCubit():super(DataInitial());

  Future<void> getEpisodes({required int contentId,required int seasonNumber,bool updateSeason=false}) async {

    final currentSeasonEpisodeState= _state[seasonNumber]?? DataInitial();
    final oldEpisodesData= _episodes[seasonNumber];
    // print('season $seasonNumber episodes length: ${oldEpisodesData?.previousLoadedEpisodes.length}');
    // print('season $seasonNumber episodes state : ${_state[seasonNumber]} ${oldEpisodesData!=null}');

    if(oldEpisodesData!=null && oldEpisodesData.hasReachedMax){
      final oldEpisodes= oldEpisodesData.previousLoadedEpisodes;
      // print('previous loaded episodes length: ${oldEpisodes.length}');

      if(currentSeasonEpisodeState is DataLoaded<List<EpisodeModel>> && !currentSeasonEpisodeState.hasReachedMax) {
        _state[seasonNumber]=DataLoaded<List<EpisodeModel>>(data: oldEpisodes,isLoadingMore: false,hasReachedMax: true);
        // print('old $currentSeasonEpisodeState');
        emit(_state[seasonNumber]!);
      }
      else if(updateSeason){
        emit(_state[seasonNumber]!);
      }
      return;
    }


    if(currentSeasonEpisodeState is DataLoading ||
        (currentSeasonEpisodeState is DataLoaded<List<EpisodeModel>> &&
            (currentSeasonEpisodeState.isLoadingMore || currentSeasonEpisodeState.hasReachedMax))) {
      // print('episodes returned of season $seasonNumber');
      return;
    }

    final bool isFirstLoad = currentSeasonEpisodeState is DataInitial;

    if (isFirstLoad) {
      _state[seasonNumber]= DataLoading();
      emit(_state[seasonNumber]!);
    }
    else if (currentSeasonEpisodeState is DataLoaded<List<EpisodeModel>>) {
      _state[seasonNumber]=currentSeasonEpisodeState.copyWith(isLoadingMore: true);
      emit(_state[seasonNumber]!);
    }


    final res= await DioApi().getSeasonEpisodes(contentId: contentId, seasonNumber: seasonNumber, pageItems: 5, pageNumber: oldEpisodesData?.pageNumber??1);
    // print('Episodes loaded of season $seasonNumber page: ${oldEpisodesData?.pageNumber} $res');
    if(isClosed) return;
    res.fold(
            (failure){
              _state[seasonNumber]= DataFailed(failure: Failure(msg: failure.msg));
              emit(_state[seasonNumber]!);
        },

            (episodes){
          final oldEpisodes= oldEpisodesData?.previousLoadedEpisodes??[];
          oldEpisodes.addAll(episodes);
          if(oldEpisodesData==null){
            _episodes[seasonNumber]= EpisodesData(previousLoadedEpisodes: oldEpisodes,pageNumber: 2);
          }
          else{
            oldEpisodesData.previousLoadedEpisodes= oldEpisodes;
            oldEpisodesData.pageNumber++;
            oldEpisodesData.hasReachedMax=episodes.isEmpty;
          }

          // print(oldEpisodesData?.pageNumber);

          // _episodes[seasonNumber]= oldEpisodesData;

          _state[seasonNumber]=DataLoaded<List<EpisodeModel>>(data: oldEpisodes,isLoadingMore: false,hasReachedMax: episodes.isEmpty);
          emit(_state[seasonNumber]!);
        }
    );
  }


  Future<void> loadMore({required int contentId,required int seasonNumber,}) async {

    final currentSeasonEpisodeState= _state[seasonNumber]?? DataInitial();
    final oldEpisodesData= _episodes[seasonNumber];
    print('season $seasonNumber episodes length: ${oldEpisodesData?.previousLoadedEpisodes.length}');
    // print('season $seasonNumber episodes state : ${_state[seasonNumber]} ${oldEpisodesData!=null}');

    if(oldEpisodesData!=null && oldEpisodesData.hasReachedMax){
      final oldEpisodes= oldEpisodesData.previousLoadedEpisodes;
      print('previous loaded episodes length: ${oldEpisodes.length}');

      if(currentSeasonEpisodeState is DataLoaded<List<EpisodeModel>> && !currentSeasonEpisodeState.hasReachedMax) {
        _state[seasonNumber]=DataLoaded<List<EpisodeModel>>(data: oldEpisodes,isLoadingMore: false,hasReachedMax: true);
        print('old $currentSeasonEpisodeState');
      }
      return;
    }

    if(currentSeasonEpisodeState is DataLoading ||
        (currentSeasonEpisodeState is DataLoaded<List<EpisodeModel>> &&
            (currentSeasonEpisodeState.isLoadingMore || currentSeasonEpisodeState.hasReachedMax))) {
      print('episodes returned of season $seasonNumber');
      return;
    }

    if (currentSeasonEpisodeState is DataLoaded<List<EpisodeModel>>) {
      _state[seasonNumber]=currentSeasonEpisodeState.copyWith(isLoadingMore: true);
      emit(_state[seasonNumber]!);
    }

    final res= await DioApi().getSeasonEpisodes(contentId: contentId, seasonNumber: seasonNumber, pageItems: 5, pageNumber: oldEpisodesData?.pageNumber??1);
    print('Episodes loaded of season $seasonNumber page: ${oldEpisodesData?.pageNumber} $res');
    if(isClosed) return;
    res.fold(
            (failure){
          _state[seasonNumber]= DataFailed(failure: Failure(msg: failure.msg));
          emit(_state[seasonNumber]!);
        },

            (episodes){
          final oldEpisodes= oldEpisodesData?.previousLoadedEpisodes??[];
          oldEpisodes.addAll(episodes);
          print('oldep size: ${oldEpisodes.length}');
          oldEpisodesData?.previousLoadedEpisodes= oldEpisodes;
          oldEpisodesData?.pageNumber++;
          oldEpisodesData?.hasReachedMax=episodes.isEmpty;
          if(oldEpisodesData==null){
            _episodes[seasonNumber]= EpisodesData(previousLoadedEpisodes: oldEpisodes,pageNumber: 2);
          }
          else{
            oldEpisodesData.previousLoadedEpisodes= oldEpisodes;
            oldEpisodesData.pageNumber++;
            oldEpisodesData.hasReachedMax=episodes.isEmpty;
          }


          _state[seasonNumber]=DataLoaded<List<EpisodeModel>>(data: oldEpisodes,isLoadingMore: false,hasReachedMax: episodes.isEmpty);
          emit(_state[seasonNumber]!);
        }
    );
  }




}

class EpisodesData{
  List<EpisodeModel> previousLoadedEpisodes;
  int pageNumber;
  bool hasReachedMax;

  EpisodesData({required this.previousLoadedEpisodes, this.hasReachedMax=false,this.pageNumber=1});
}


sealed class EpisodesState{}

final class EpisodeInitial extends EpisodesState{

  EpisodeInitial();
}
final class EpisodeLoading extends EpisodesState{
  final int seasonNumber;

  EpisodeLoading({required this.seasonNumber});
}
final class EpisodeLoaded extends EpisodesState{
  final int seasonNumber;
  final List<EpisodeModel> episodes;

  EpisodeLoaded({required this.seasonNumber,required this.episodes});
}
final class EpisodeFailed extends EpisodesState{
  final int seasonNumber;

  EpisodeFailed({required this.seasonNumber});
}