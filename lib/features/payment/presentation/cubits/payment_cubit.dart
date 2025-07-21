import 'package:shawn/core/utils/device_details.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/links.dart';

class PaymentCubit extends Cubit<PaymentState>{
  late IO.Socket socket;

  final String socketLink=baseApiUrl;
  PaymentCubit():super(PaymentInitial());

  Future<void> connectAndRegister() async {
    final deviceID= await DeviceDetails.getDeviceId();

    socket = IO.io(socketLink,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket');

      socket.emit('register', {'deviceID': deviceID});
    });



    socket.on('success', (data) {
      print('📥 Received: $data');
      print('📥 isSuccess: ${data['data']['value']}');

      if(!isClosed){
        if (data['data']['value'] == true) {
          emit(PaymentSuccess());
          // emit(SocketRegisterSuccess());
        } else {
          emit(PaymentFailed());
          // emit(SocketRegisterFailure('Registration failed'));
        }
      }
    });

    socket.onConnectError((err) {
      print('Connect Error: $err');
      // emit(SocketRegisterFailure('Connection error: $err'));
    });

    socket.onError((err) {
      print('On Error: $err');
      // emit(SocketRegisterFailure('Socket error: $err'));
    });
  }

  @override
  Future<void> close() {
    socket.disconnect();
    return super.close();
  }

}

sealed class PaymentState{}

final class PaymentInitial extends PaymentState{}
final class PaymentSuccess extends PaymentState{}
final class PaymentFailed extends PaymentState{}