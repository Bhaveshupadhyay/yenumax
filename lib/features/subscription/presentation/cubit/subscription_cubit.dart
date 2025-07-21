import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/features/subscription/model/subscription_model.dart';

class SubscriptionCubit extends Cubit<SubscriptionState>{

  SubscriptionCubit():super(SubscriptionInitial());

  Future<void> getSubscription() async {
    emit(SubscriptionLoading());
    final res= await DioApi().getSubscription();
    res.fold(
            (failure){
          emit(SubscriptionFailed(msg: failure.msg??''));
        },
            (subscriptionModel){
              emit(SubscriptionLoaded(subscriptionModel));
        }
    );
  }
}
sealed class SubscriptionState{}
final class SubscriptionInitial extends SubscriptionState{}
final class SubscriptionLoading extends SubscriptionState{}
final class SubscriptionLoaded extends SubscriptionState{
  final SubscriptionModel subscriptionModel;

  SubscriptionLoaded(this.subscriptionModel);
}

final class SubscriptionFailed extends SubscriptionState{
  final String msg;

  SubscriptionFailed({required this.msg});
}

