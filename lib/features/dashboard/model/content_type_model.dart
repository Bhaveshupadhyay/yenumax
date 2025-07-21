class ContentTypeModel {
  final String contentTypeName;
  final int id;
  final String title;
  final String posterImage;
  final String contentType;

  ContentTypeModel({
    required this.contentTypeName,
    required this.id,
    required this.title,
    required this.posterImage,
    required this.contentType,
  });

  factory ContentTypeModel.fromJson(Map<String, dynamic> json) {
    return ContentTypeModel(
      contentTypeName: json['name'],
      id: json['id'],
      title: json['title'],
      posterImage: json['poster_image'],
      contentType: json['content_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': contentTypeName,
      'id': id,
      'title': title,
      'poster_image': posterImage,
      'content_type': contentType,
    };
  }
}
