import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/features/dashboard/model/slider_model.dart';

import '../../../../core/service/failure.dart';
import '../../../../core/service/network_api.dart';

class SliderCubit extends Cubit<DataState>{
  SliderCubit():super(DataInitial());

  Future<void> getSlider() async {
    emit(DataLoading());

    final res=await DioApi().loadSlider();
    res.fold(
            (failure){
          emit(DataFailed(failure: Failure(msg: failure.msg)));
        },
            (data){
          emit(DataLoaded<List<SliderModel>>(data: data));
        }
    );
  }

}