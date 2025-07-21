import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shawn/core/service/network_api.dart';
import 'package:shawn/core/utils/device_details.dart';
import 'package:shawn/features/auth/models/auth_model.dart';

class AuthCubit extends Cubit<AuthState>{
  final Api _api;
  AuthCubit({required Api api}):
        _api=api,
        super(AuthInitial());

  Future<void> login(String email,String password) async {

    final validResponseMsg =validate(email, password);
    if(validResponseMsg.isNotEmpty){
      emit(AuthFailed(validResponseMsg));
      return;
    }
    emit(AuthLoading());
    final deviceId= await DeviceDetails.getDeviceId()??'N/A';
    final deviceName= await DeviceDetails.getDeviceName()??'N/A';

    final res= await _api.login(email: email, password: password,
        country: _getCountryCode(), deviceId: deviceId, deviceName: deviceName);
    res.fold(
            (failure){
              emit(AuthFailed(failure.response?['message']??failure.msg??'An error occurred'));
            },
            (data){
              if(data.isSuccess){
                emit(AuthSuccess(authModel: data));
              }
              else{
                emit(AuthFailed('Login Failed'));
              }
            }
    );
  }

  Future<void> register({required String email, required String password}) async {
    final validResponseMsg =validate(email, password);
    if(validResponseMsg.isNotEmpty){
      emit(AuthFailed(validResponseMsg));
      return;
    }
    emit(AuthLoading());
    final deviceId= await DeviceDetails.getDeviceId()??'N/A';
    final deviceName= await DeviceDetails.getDeviceName()??'N/A';

    final res= await _api.signUp(email: email, password: password, confirmPassword: password,
        country: _getCountryCode(), deviceId: deviceId, deviceName: deviceName);
    if(isClosed) return;
    res.fold(
            (failure){
          emit(AuthFailed(failure.msg??'An error occurred'));
        },
            (data){
          if(data.isSuccess){
            emit(AuthSuccess(authModel: data));
          }
          else{
            emit(AuthFailed('Login Failed'));
          }
        }
    );
  }

  // Future<void> isLoggedIn() async {
  //   if(await Api.instance.isLoggedIn()){
  //     emit(AuthLoggedIn());
  //   }
  //   else{
  //     emit(AuthNotLoggedIn());
  //   }
  // }

  // Future<void> uploadProfileImg(String email,String password,String name,String path)async {
  //   // print('path $path');
  //   if(path.isEmpty){
  //     emit(AuthFailed('Image is required'));
  //     return;
  //   }
  //   if(name.isEmpty){
  //     emit(AuthFailed('Name is required'));
  //     return;
  //   }
  //   emit(AuthLoading());
  //   String? img;
  //   if(path.isNotEmpty){
  //     img= await Api.instance.uploadImage(path);
  //     if(img.isEmpty){
  //       emit(AuthFailed('Image not uploaded'));
  //       return;
  //     }
  //   }
  //   String ip= await Api.instance.getIp();
  //   print("$email, $password, $name, $img, $ip");
  //   register(email, password, name, img??'', ip);
  // }

  String validate(String email,String password) {
    if(!EmailValidator.validate(email)){
      return 'Invalid email';
    }
    if(validatePass(password).isNotEmpty){
      return validatePass(password);
    }
    return '';
  }

  String validatePass(String pass){
    if(pass.trim().isEmpty){
      return "Password can't be empty";
    }
    else if(pass.length<=4){
      return "Password length should be more than 4";
    }
    return '';
  }

  String _getCountryCode()=>
      WidgetsBinding.instance.platformDispatcher.locale.countryCode??'N/A';
}

abstract class AuthState{}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthSuccess extends AuthState{
  final AuthModel authModel;

  AuthSuccess({required this.authModel});
}

class AuthFailed extends AuthState{
  final String errorMsg;

  AuthFailed(this.errorMsg);
}

class AuthLoggedIn extends AuthState{}
class AuthNotLoggedIn extends AuthState{}


class PasswordCubit extends Cubit<PasswordState>{
  bool _isVisible=false;

  PasswordCubit():super(PasswordInvisible());

  void toggle(){
    if(_isVisible){
      emit(PasswordInvisible());
      _isVisible=false;
    }
    else{
      emit(PasswordVisible());
      _isVisible=true;
    }
  }

}

abstract class PasswordState{}

class PasswordVisible extends PasswordState{}
class PasswordInvisible extends PasswordState{}