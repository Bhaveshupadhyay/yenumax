
class HomeContentsModel{
  final String title;
  final bool isTrending;
  final List<HomeContentModel> items;

  HomeContentsModel({
    required this.title,
    required this.isTrending,
    required this.items
  });

  factory HomeContentsModel.fromJson(Map<String, dynamic> json) {
    return HomeContentsModel(
      title: json['name'],
      isTrending: json['isTrending'],
      items: List<HomeContentModel>.from(json['items'].map((item) => HomeContentModel.fromJson(item))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'isTrending': isTrending,
      'items': items,
    };
  }

}

class HomeContentModel {
  final int contentId;
  final String contentTitle;
  final String posterImg;
  final int contentType;

  HomeContentModel({
    required this.contentId,
    required this.contentTitle,
    required this.posterImg,
    required this.contentType,
  });

  factory HomeContentModel.fromJson(Map<String, dynamic> json) {
    return HomeContentModel(
      contentId: json['id'],
      contentTitle: json['title'],
      posterImg: json['poster_image'],
      contentType: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': contentId,
      'title': contentTitle,
      'poster_image': posterImg,
    };
  }
}