import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/model/similar_content_model.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/core/service/network_api.dart';

class SimilarCubit extends Cubit<DataState>{

  SimilarCubit():super(DataInitial());
  
  Future<void> getSimilarContent({required int contentId, required int contentType}) async {
    emit(DataLoading());

    final res=await DioApi().loadSimilarContent(contentId: contentId, pageItems: 5, pageNumber: 1, contentType: contentType);
    res.fold(
            (failure){
              emit(DataFailed(failure: Failure(msg: failure.msg)));
            },
            (data){
              emit(DataLoaded<List<SimilarContentModel>>(data: data));
            }
    );
  }
}