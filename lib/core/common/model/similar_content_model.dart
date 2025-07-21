class SimilarContentModel {
  final int contentId;
  final String title;
  final String posterImage;
  final int contentType;

  SimilarContentModel({
    required this.contentId,
    required this.title,
    required this.posterImage,
    required this.contentType,
  });

  factory SimilarContentModel.fromJson(Map<String, dynamic> json) {
    return SimilarContentModel(
      contentId: json['id'],
      title: json['title'],
      posterImage: json['poster_image'],
      contentType: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': contentId,
      'title': title,
      'poster_image': posterImage,
      'type': contentType,
    };
  }
}
