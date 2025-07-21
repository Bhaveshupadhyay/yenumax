class VideoQualityModel {
  final String quality;
  final int resolution;
  final String link;

  VideoQualityModel({
    required this.quality,
    required this.resolution,
    required this.link,
  });

  // Factory constructor to create an instance from JSON
  factory VideoQualityModel.fromJson(Map<String, dynamic> json) {
    return VideoQualityModel(
      quality: json['quality'],
      resolution: json['resolution'],
      link: json['link'],
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'quality': quality,
      'resolution': resolution,
      'link': link,
    };
  }
}
