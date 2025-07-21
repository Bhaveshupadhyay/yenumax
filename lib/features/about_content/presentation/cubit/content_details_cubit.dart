import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/features/dashboard/model/content_model.dart';

import '../../../../core/service/network_api.dart';

class ContentDetailsCubit extends Cubit<DataState>{
  final Api api;
  ContentDetailsCubit(this.api): super(DataInitial());

  Future<void> loadContentById({required int contentId, int? contentType}) async {
    emit(DataLoading());
    final res= await api.getContentById(id: contentId,contentType: contentType);
    if(isClosed) return;
    res.fold(
            (failure){
              emit(DataFailed(failure: Failure(msg: failure.msg)));
            },
            (content){
              emit(DataLoaded<ContentModel>(data: content));
            }
    );
  }
}