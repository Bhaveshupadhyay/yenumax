import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/service/failure.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/core/utils/device_details.dart';
import 'package:shawn/features/profile/model/connected_device_model.dart';

class DeviceCubit extends Cubit<ConnectedDeviceState>{

  DeviceCubit():super(ConnectedDeviceInitial());

  Future<void> getAllDevices() async {
    emit(ConnectedDeviceLoading());
    final res= await DioApi().getAllConnectedDevices();
    final myDeviceId= await DeviceDetails.getDeviceId();
    if(isClosed) return;

    res.fold(
            (failure){
              emit(ConnectedDeviceFailedToLoad(failure: Failure(msg: failure.msg)));
            },
            (devices){
              emit(ConnectedDeviceLoaded(connectedDevices: devices, myDeviceId: myDeviceId));
            }
    );
  }

  Future<void> updateDeviceDetails({required String deviceName, required String deviceId}) async {
    if(state is ConnectedDeviceDetailsDeleting) return;
    emit(ConnectedDeviceDetailsUpdating());
    final res= await DioApi().updateConnectedDeviceName(deviceName: deviceName, deviceId: deviceId);
    if(isClosed) return;

    res.fold(
            (failure){
              emit(ConnectedDeviceFailedToUpdateDetails(failure: Failure(msg: failure.msg)));
              },
            (isSuccess){
              if(isSuccess){
                emit(ConnectedDeviceDetailsUpdated());
              }
              else{
                emit(ConnectedDeviceFailedToUpdateDetails(failure: Failure(msg: 'Unable to update device name')));
              }
        }
    );
  }

  Future<void> removeDevice({required String deviceId}) async {
    if(state is ConnectedDeviceDetailsUpdating) return;
    emit(ConnectedDeviceDetailsDeleting());
    final res= await DioApi().removeConnectedDevice(deviceId: deviceId);
    if(isClosed) return;

    res.fold(
            (failure){
              emit(ConnectedDeviceFailedToDelete(failure: Failure(msg: failure.msg)));
              },
            (removedDeviceModel){
              if(removedDeviceModel.isRemoved){
                emit(ConnectedDeviceDetailsDeleted());
              }
              else{
                emit(ConnectedDeviceFailedToDelete(failure: Failure(msg: removedDeviceModel.message)));
              }
        }
    );
  }
}

sealed class ConnectedDeviceState{}

final class ConnectedDeviceInitial extends ConnectedDeviceState{}
final class ConnectedDeviceLoading extends ConnectedDeviceState{}

final class ConnectedDeviceLoaded extends ConnectedDeviceState{
  final ConnectedDevicesModel connectedDevices;
  final String? myDeviceId;

  ConnectedDeviceLoaded({required this.connectedDevices,this.myDeviceId,});
}

final class ConnectedDeviceFailedToLoad extends ConnectedDeviceState{
  final Failure failure;

  ConnectedDeviceFailedToLoad({required this.failure});
}
final class ConnectedDeviceDetailsUpdating extends ConnectedDeviceState{}
final class ConnectedDeviceDetailsUpdated extends ConnectedDeviceState{}

final class ConnectedDeviceFailedToUpdateDetails extends ConnectedDeviceState{
  final Failure failure;

  ConnectedDeviceFailedToUpdateDetails({required this.failure});
}
final class ConnectedDeviceDetailsDeleting extends ConnectedDeviceState{}
final class ConnectedDeviceDetailsDeleted extends ConnectedDeviceState{}

final class ConnectedDeviceFailedToDelete extends ConnectedDeviceState{
  final Failure failure;

  ConnectedDeviceFailedToDelete({required this.failure});
}


