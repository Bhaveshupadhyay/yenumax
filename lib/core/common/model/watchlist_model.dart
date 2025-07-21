class WatchlistModel {
  final int contentId;
  final int contentType;
  final String title;
  final String posterImage;
  final int duration;

  WatchlistModel({
    required this.contentId,
    required this.contentType,
    required this.title,
    required this.posterImage,
    required this.duration,
  });

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      contentId: json['id'] ?? 0,
      contentType: json['type'] ?? 0,
      title: json['title'] ?? '',
      posterImage: json['poster_image'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': contentId,
      'type': contentType,
      'title': title,
      'backdrop_image': posterImage,
      'duration': duration,
    };
  }
}
