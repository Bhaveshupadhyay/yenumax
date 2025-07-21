import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/features/dashboard/model/home_contents_model.dart';

class HomeCubit extends Cubit<DataState>{

  final Api api;
  final List<HomeContentsModel> _homeContents=[];
  int _pageNumber=1;

  
  HomeCubit({required this.api}):super(DataInitial());

  Future<void> loadHome() async {
    if(state is DataLoading ||
        (state is DataLoaded<List<HomeContentsModel>> &&
            ((state as DataLoaded<List<HomeContentsModel>>).isLoadingMore || (state as DataLoaded<List<HomeContentsModel>>).hasReachedMax))) {
      return;
    }

    final bool isFirstLoad = state is DataInitial;

    if (isFirstLoad) {
      emit(DataLoading());
    }
    else if (state is DataLoaded<List<HomeContentsModel>>) {
      emit((state as DataLoaded<List<HomeContentsModel>>).copyWith(isLoadingMore: true));
    }


    final res= await api.loadHomeItems(pageItems: 3, pageNumber: _pageNumber);

    if(isClosed) return;
    res.fold(
        (failure){
          final fail=Failure(msg: failure.msg);
          if(isFirstLoad){
            emit(DataFailed(failure: fail));
          }
          // emit(_pageNumber==1? DataFailed(failure: fail) : DataMoreFailed<List<HomeContentsModel>>(failure: fail, oldData: _homeContents));
        },
        (homeContents){
          _pageNumber++;
          _homeContents.addAll(homeContents);
          emit(DataLoaded<List<HomeContentsModel>>(data: _homeContents, isLoadingMore: false,hasReachedMax: homeContents.isEmpty));
        }
    );
  }


}