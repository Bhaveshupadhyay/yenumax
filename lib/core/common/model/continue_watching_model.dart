class ContinueWatchingModel {
  final int contentId;
  final int contentType;
  final int progressInSeconds;
  final String title;
  final String backdropImage;
  final int totalContentDuration;

  ContinueWatchingModel({
    required this.contentId,
    required this.contentType,
    required this.progressInSeconds,
    required this.title,
    required this.backdropImage,
    required this.totalContentDuration,
  });

  factory ContinueWatchingModel.fromJson(Map<String, dynamic> json) {
    return ContinueWatchingModel(
      contentId: json['id'] ?? 0,
      contentType: json['type'] ?? 0,
      progressInSeconds: json['progress_in_seconds'] ?? 0,
      title: json['title'] ?? '',
      backdropImage: json['backdrop_image'] ?? '',
      totalContentDuration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': contentId,
      'type': contentType,
      'progress_in_seconds': progressInSeconds,
      'title': title,
      'backdrop_image': backdropImage,
      'duration': totalContentDuration,
    };
  }

  /// Optional: get progress as a percentage (0.0 to 1.0)
  double get progressPercent {
    if (totalContentDuration == 0) return 0;
    return progressInSeconds / totalContentDuration;
  }
}
