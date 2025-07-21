import 'package:shawn/features/video_play/model/video_quality_model.dart';

class VideoModel {
  final bool isCustomerExist;
  final bool isSubActive;
  final int reasonCode;
  final List<VideoQualityModel> videoQualities;

  VideoModel({
    required this.isCustomerExist,
    required this.isSubActive,
    required this.reasonCode,
    required this.videoQualities,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      isCustomerExist: json['isCustomerExist'] ?? false,
      isSubActive: json['isSubActive'] ?? false,
      reasonCode: json['reasonCode'] ?? 0,
      videoQualities: (json['result'] as List).map((e)=>VideoQualityModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCustomerExist': isCustomerExist,
      'isSubActive': isSubActive,
      'reasonCode': reasonCode,
    };
  }
}
