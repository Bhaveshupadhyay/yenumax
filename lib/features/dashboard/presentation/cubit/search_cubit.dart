import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/features/dashboard/model/search_model.dart';

import '../../../../core/service/failure.dart';
import '../../../../core/service/network_api.dart';

class SearchCubit extends Cubit<DataState>{

  SearchCubit():super(DataInitial());

  Future<void> search({required String q}) async {
    emit(DataLoading());

    final res=await DioApi().search(q: q);
    res.fold(
            (failure){
          emit(DataFailed(failure: Failure(msg: failure.msg)));
        },
            (data){
          emit(DataLoaded<SearchModel>(data: data));
        }
    );
  }
}