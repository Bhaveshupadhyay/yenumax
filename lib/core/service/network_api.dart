import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shawn/core/common/model/continue_watching_model.dart';
import 'package:shawn/core/common/model/similar_content_model.dart';
import 'package:shawn/core/common/model/watchlist_model.dart';
import 'package:shawn/core/service/server_exception.dart';
import 'package:shawn/core/service/token_api.dart';
import 'package:shawn/core/utils/device_details.dart';
import 'package:shawn/features/about_content/model/episode_model.dart';
import 'package:shawn/features/auth/models/auth_model.dart';
import 'package:shawn/features/dashboard/model/content_model.dart';
import 'package:shawn/features/dashboard/model/content_type_model.dart';
import 'package:shawn/features/dashboard/model/home_contents_model.dart';
import 'package:shawn/features/dashboard/model/search_model.dart';
import 'package:shawn/features/dashboard/model/slider_model.dart';
import 'package:shawn/features/payment/model/payment_model.dart';
import 'package:shawn/features/profile/model/connected_device_model.dart';
import 'package:shawn/features/profile/model/removed_device_model.dart';
import 'package:shawn/features/subscription/model/subscription_model.dart';
import 'package:shawn/features/video_play/model/video_model.dart';
import 'package:shawn/features/video_play/model/video_quality_model.dart';

import '../constant/links.dart';

abstract class Api{
  Future<Either<ServerException,AuthModel>> login({required String email, required String password,
    required String country, required String deviceId, required String deviceName});
  Future<Either<ServerException,AuthModel>> signUp({required String email, required String password,
    required String confirmPassword, required String country, required String deviceId, required String deviceName});

  Future<Either<ServerException,List<ContentTypeModel>>> loadDataByContentType({required int contentId, required int pageItems,
    required int pageNumber});
  Future<Either<ServerException,List<int>>> getContentTypes();
  Future<Either<ServerException,ContentModel>> getContentById({required int id,int? contentType});
  Future<Either<ServerException,List<HomeContentsModel>>> loadHomeItems({required int pageItems,
    required int pageNumber});
  Future<Either<ServerException,int>> getSeasonsCount({required int contentId});
  Future<Either<ServerException,List<EpisodeModel>>> getSeasonEpisodes({required int contentId, required int seasonNumber,
    required int pageItems, required int pageNumber});
  Future<Either<ServerException,List<SimilarContentModel>>> loadSimilarContent({
    required int contentId, required int pageItems,
    required int pageNumber,required int contentType});
  Future<Either<ServerException,List<SliderModel>>> loadSlider();
  Future<Either<ServerException,SearchModel>> search({required String q});
  Future<Either<ServerException,List<VideoQualityModel>>> getTrailerVideoLink({
    required int contentId,
    required int contentType,
  });
  Future<Either<ServerException,PaymentModel>> getPaymentLink();
  Future<Either<ServerException,ConnectedDevicesModel>> getAllConnectedDevices();
  Future<Either<ServerException,bool>> updateConnectedDeviceName({required String deviceName, required String deviceId});
  Future<Either<ServerException,RemovedDevicesModel>> removeConnectedDevice({required String deviceId});
  Future<Either<ServerException,SubscriptionModel>> getSubscription();
  Future<Either<ServerException,bool>> addToWatchList({required int contentId, required int contentType});
  Future<Either<ServerException,List<WatchlistModel>>> getWatchlist();
  Future<Either<ServerException,List<ContinueWatchingModel>>> getContinueWatching();
  Future<Either<ServerException,VideoModel>> getVideo({required int contentId,required int contentType,});




  Future<Response> hitApi({required String pathUrl, String? data, bool setHeaders=true,
    String method='GET',Map<String,dynamic>? queryParameters});

}

class DioApi implements Api{
  final Dio _dio= Dio(BaseOptions(baseUrl: baseApiUrl));


  @override
  Future<Either<ServerException,AuthModel>> login({required String email, required String password,
    required String country, required String deviceId, required String deviceName}) async {

    try{
      final data = jsonEncode({
        "email": email,
        "password": password,
        "country": country,
        "device_id": deviceId,
        "device_name": deviceName
      });
      final res= await hitApi(pathUrl: '/api/v1/auth/sign-in', data: data,setHeaders: false,method: 'POST');
      final authModel= AuthModel.fromJson(res.data);
      if(authModel.token!=null) {
        final setCookie = res.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) {
          final fullCookie = setCookie.first;

          final cookieKeyValue = fullCookie.split(';').first;
          await TokenApi().saveCookie(token: authModel.token!, cookie: cookieKeyValue);
        }

      }
      return right(authModel);
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, AuthModel>> signUp({required String email, required String password,
    required String confirmPassword, required String country, required String deviceId, required String deviceName}) async {
    try{
      final data = jsonEncode({
        "email": email,
        "password": password,
        "cpassword": confirmPassword,
        "country": country,
        "device_id": deviceId,
        "device_name": deviceName
      });
      final res= await hitApi(pathUrl: '/api/v1/auth/sign-up', data: data,setHeaders: false,method: 'POST');
      final authModel= AuthModel.fromJson(res.data);
      if(authModel.token!=null) {
        final setCookie = res.headers['set-cookie'];
        if (setCookie != null && setCookie.isNotEmpty) {
          final fullCookie = setCookie.first;

          final cookieKeyValue = fullCookie.split(';').first;
          await TokenApi().saveCookie(token: authModel.token!, cookie: cookieKeyValue);
        }
      }
      return right(authModel);
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Response> hitApi({required String pathUrl, String? data, bool setHeaders=true,
    String method='GET', Map<String,dynamic>? queryParameters}) async {

    Map<String, String>? headers;

    if(setHeaders){
      final refreshToken= await TokenApi().getRefreshToken();
      print(refreshToken);
      headers = {
        'Authorization': 'Bearer $refreshToken'
      };
    }
    try{
      final res= await _dio.request(pathUrl,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            method: method,
            headers: headers,
          )
      );
      if(res.statusCode == 200){
        print('$pathUrl $res');
        return res;
      }
      else{
        throw ServerException(
            msg: res.statusMessage,
            statusCode: res.statusCode,
            response: res.data
        );
      }
    }
    on DioException catch(e){
      throw ServerException(
          msg: e.message,
          response: e.response?.data
      );
    }
    catch(e){
      throw ServerException(
        msg: e.toString(),
      );
    }
  }

  @override
  Future<Either<ServerException, List<ContentTypeModel>>> loadDataByContentType({required int contentId,
    required int pageItems, required int pageNumber}) async {

    final Map<String, dynamic> queryParams = {
      'page_items': pageItems,
      'pgNo': pageNumber,
    };
    try{
     final res= await hitApi(pathUrl: '/api/v1/users/trailers/$contentId/content?',
         queryParameters: queryParams,
         setHeaders: false
      );
     if(res.data['isSuccess']){
       final data= res.data['data']['result'] as List;
       final List<ContentTypeModel> list= data.map((e)=>ContentTypeModel.fromJson(e)).toList();
       return right(list);
     }
     return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<int>>> getContentTypes() async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/content_type',
          setHeaders: false
      );
      if(res.data['isSuccess']){
        final data= res.data['data'] as List<int>;
        return right(data);
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, ContentModel>> getContentById({required int id,int? contentType}) async {
    final myDeviceId= await DeviceDetails.getDeviceId();

    try{
      final res= await hitApi(pathUrl: '/api/v1/users/content/$id',
          setHeaders: TokenApi.isUserLoggedIn(), // set token only if the user is loggedIn
        queryParameters: {
          'type': contentType,
          'device': myDeviceId
        }
      );
      if(res.data['isSuccess']){
        return right(ContentModel.fromJson(res.data['data']));
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<HomeContentsModel>>> loadHomeItems({required int pageItems, required int pageNumber}) async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/home',
          setHeaders: false,
        queryParameters: <String,dynamic>{
        'pgNo': pageNumber,
        'page_items': pageItems,
        }
      );
      if(res.data['isSuccess']){
        final data= res.data['data']['result'] as List;
        final homeContentList= data.map((e)=>HomeContentsModel.fromJson(e)).toList();
        return right(homeContentList);
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, int>> getSeasonsCount({required int contentId}) async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/trailers/$contentId/series',
          setHeaders: false,
      );
      if(res.data['isSuccess']){
        return right(res.data['data']['season_count']??0);
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<EpisodeModel>>> getSeasonEpisodes({required int contentId, required int seasonNumber,
    required int pageItems, required int pageNumber}) async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/trailers/$contentId/$seasonNumber/episodes',
          setHeaders: false,
          queryParameters: <String,dynamic>{
            'pgNo': pageNumber,
            'page_items': pageItems,
          }
      );
      if(res.data['isSuccess']){
        final data= res.data['data']['result'] as List;
        final episodes= data.map((e)=>EpisodeModel.fromJson(e)).toList();
        return right(episodes);
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<SimilarContentModel>>> loadSimilarContent({required int contentId, required int contentType, required int pageItems, required int pageNumber}) async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/similar-videos',
          setHeaders: false,
          queryParameters: <String,dynamic>{
            'pgNo': pageNumber,
            'page_items': pageItems,
            'id': contentId,
            'type': contentType,
          }
      );
      if(res.data['isSuccess']){
        final data= res.data['data'] as List;
        final similarContents= data.map((e)=>SimilarContentModel.fromJson(e)).toList();
        return right(similarContents);
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<SliderModel>>> loadSlider() async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/slider',
          setHeaders: false,
      );
      if(res.data['isSuccess']){
        final data= res.data['data'] as List;
        final sliderContents= data.map((e)=>SliderModel.fromJson(e)).toList();
        return right(sliderContents);
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, SearchModel>> search({required String q}) async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/search',
        setHeaders: false,
        queryParameters: <String,dynamic>{
        'q': q
        }
      );
      if(res.data['isSuccess']){
        final data= res.data['data'];
        return right(SearchModel.fromJson(data));
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<VideoQualityModel>>> getTrailerVideoLink({required int contentId,required int contentType}) async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/trailer/video/$contentId/$contentType',
          setHeaders: false,
      );
      if(res.data['isSuccess']){
        final data= res.data['data']['result'] as List;
        return right(data.map((e)=>VideoQualityModel.fromJson(e)).toList());
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, PaymentModel>> getPaymentLink() async {
    final myDeviceId= await DeviceDetails.getDeviceId();

    try{

      final res= await hitApi(pathUrl: '/api/v1/weblink/generate-link/$myDeviceId',
        setHeaders: true,
      );
      if(res.data['isSuccess']){
        return right(PaymentModel.fromJson(res.data));
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      print(e.msg);
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, ConnectedDevicesModel>> getAllConnectedDevices() async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/users/devices',
        setHeaders: true,
      );
      if(res.data['isSuccess']){
        return right(ConnectedDevicesModel.fromJson(res.data['data']));
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, bool>> updateConnectedDeviceName({required String deviceName, required String deviceId}) async {
    try{
      final data = jsonEncode({
        "device_name": deviceName,
        "device_id": deviceId
      });

      final res= await hitApi(pathUrl: '/api/v1/users/devices',
        setHeaders: true,
        method: 'PUT',
        data: data
      );
      return right(res.data['isSuccess']);
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, RemovedDevicesModel>> removeConnectedDevice({required String deviceId}) async {
    final myDeviceId= await DeviceDetails.getDeviceId();
    try{
      final data = jsonEncode({
        "device_id": deviceId,
        "current_device_id": myDeviceId,
      });

      final res= await hitApi(pathUrl: '/api/v1/users/remove-device',
        setHeaders: true,
        method: 'POST',
        data: data
      );
      return right(RemovedDevicesModel.fromJson(res.data));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, SubscriptionModel>> getSubscription() async {
    try{
      final res= await hitApi(pathUrl: '/api/v1/payments/subscriptions-status',
        setHeaders: true,
        method: 'POST'
      );
      if(res.data['isCustomerExist']){
        return right(SubscriptionModel.fromJson(res.data));
      }
      return left(ServerException(msg: 'Failed to load data'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, bool>> addToWatchList({required int contentId, required int contentType}) async {
    final myDeviceId= await DeviceDetails.getDeviceId();
    try{
      final data = jsonEncode({
        "device_id": myDeviceId,
        "content_id": contentId,
        "content_type": contentType,
        "video_type": 2, // the video_type:2 here is video
      });

      final res= await hitApi(pathUrl: '/api/v1/users/bookmark',
          setHeaders: true,
          method: 'POST',
          data: data
      );
      return right(res.data['isAdded']);
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<WatchlistModel>>> getWatchlist() async {
    final myDeviceId= await DeviceDetails.getDeviceId();
    try{

      final res= await hitApi(pathUrl: '/api/v1/users/bookmark',
          setHeaders: true,
          queryParameters: {
        'device': myDeviceId
          }
      );

      final data= res.data['data'] as List;
      return right(data.map((e)=>WatchlistModel.fromJson(e)).toList());
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, List<ContinueWatchingModel>>> getContinueWatching() async {
    final myDeviceId= await DeviceDetails.getDeviceId();
    try{

      final res= await hitApi(pathUrl: '/api/v1/users/continue-watching',
          setHeaders: true,
          queryParameters: {
            'device_id': myDeviceId
          }
      );

      final data= res.data['data'] as List;
      return right(data.map((e)=>ContinueWatchingModel.fromJson(e)).toList());
    }
    on ServerException catch(e){
      return left(e);
    }
  }

  @override
  Future<Either<ServerException, VideoModel>> getVideo({required int contentId,required int contentType,}) async {
    final myDeviceId= await DeviceDetails.getDeviceId();
    try{

      final res= await hitApi(pathUrl: '/api/v1/users/video/$contentId/$contentType',
          setHeaders: true,
          queryParameters: {
            'device_id': myDeviceId
          }
      );
      final data= res.data['data'];
      if(res.data['isSuccess']) {
        return right(VideoModel.fromJson(data));
      }
     return left(ServerException(msg: 'An error occurred'));
    }
    on ServerException catch(e){
      return left(e);
    }
  }
}