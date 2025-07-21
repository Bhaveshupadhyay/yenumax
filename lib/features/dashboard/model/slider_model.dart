class SliderModel {
  final int type;
  final int id;
  final String title;
  final String posterImage;

  SliderModel({
    required this.type,
    required this.id,
    required this.title,
    required this.posterImage,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      type: json['type'],
      id: json['id'],
      title: json['title'],
      posterImage: json['poster_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'poster_image': posterImage,
    };
  }
}
