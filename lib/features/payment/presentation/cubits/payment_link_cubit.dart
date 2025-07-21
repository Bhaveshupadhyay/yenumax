import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/features/payment/model/payment_model.dart';


class PaymentLinkCubit extends Cubit<DataState>{

  PaymentLinkCubit():super(DataInitial());

  Future<void> getPaymentLink() async {
    emit(DataLoading());
    final res= await DioApi().getPaymentLink();
    res.fold(
            (failure){
              emit(DataFailed(failure: Failure(msg: failure.msg)));
            },
            (paymentLinkDetails){
              emit(DataLoaded<PaymentModel>(data: paymentLinkDetails));
            }
    );
  }
}