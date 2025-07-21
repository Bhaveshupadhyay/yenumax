import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shawn/core/constant/links.dart';

class TokenApi{

  static final storage = const FlutterSecureStorage();
  static const authCookie= 'auth_cookie';
  static const _firstLaunchKey = 'has_launched_before';
  static String? _cookie;
  static String? _refreshToken;

  final dio= Dio(
      BaseOptions(
          baseUrl: baseApiUrl
      )
  );

  static Future<String?> getCookie() async {
    // await storage.delete(key: authCookie);
    _cookie= await storage.read(key: authCookie);
    return _cookie;
  }

  Future<void> saveCookie({required String token, required String cookie}) async {
    TokenApi._cookie= cookie;
    _refreshToken=token;
    await storage.write(key: authCookie, value: cookie);
  }

  Future<void> deleteCookie() async {
    TokenApi._cookie=null;
    await storage.delete(key: authCookie);
  }

  Future<String?> getRefreshToken() async {
    if(_refreshToken!=null && !JwtDecoder.isExpired(_refreshToken!)){
      return _refreshToken;
    }

    if(_cookie==null){
      getCookie();
    }
    var headers = {
      'Cookie': _cookie,
    };

    try{
      final response = await dio.get('/api/v1/refresh',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        if(response.data['isSuccess']){
          _refreshToken= response.data['token'];
          return _refreshToken;
        }
      }
    }
    catch (e){
      return null;
    }
    return null;
  }

  static Future<void> clearOnFreshInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunched = prefs.getBool(_firstLaunchKey);

    if (hasLaunched == null) {
      await storage.deleteAll();
      await prefs.setBool(_firstLaunchKey, true);
    }
  }

  static bool isUserLoggedIn()=>TokenApi._cookie!=null;
}