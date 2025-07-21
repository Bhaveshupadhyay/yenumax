class SearchModel{
  final List<CollectionContentModel> collections;
  final List<VideoContentModel> videos;

  SearchModel({
    required this.collections,
    required this.videos,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
        collections: List<CollectionContentModel>.from(json['collections'].map((e)=>CollectionContentModel.fromJson(e))),
        videos: List<VideoContentModel>.from(json['videos'].map((e)=>VideoContentModel.fromJson(e))),
    );
  }
}


class VideoContentModel {
  final int type;
  final int id;
  final int? partNumber;
  final int? seasonNumber;
  final String title;
  final String backdropImage;

  VideoContentModel({
    required this.type,
    required this.id,
    this.partNumber,
    this.seasonNumber,
    required this.title,
    required this.backdropImage,
  });

  factory VideoContentModel.fromJson(Map<String, dynamic> json) {
    return VideoContentModel(
      type: json['type'],
      id: json['id'],
      partNumber: json['part_number'],
      seasonNumber: json['season_number'],
      title: json['title'],
      backdropImage: json['backdrop_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'part_number': partNumber,
      'title': title,
      'backdrop_image': backdropImage,
    };
  }
}


class CollectionContentModel {
  final int type;
  final int id;
  final String title;
  final String backdropImage;

  CollectionContentModel({
    required this.type,
    required this.id,
    required this.title,
    required this.backdropImage,
  });

  factory CollectionContentModel.fromJson(Map<String, dynamic> json) {
    return CollectionContentModel(
      type: json['type'],
      id: json['id'],
      title: json['title'],
      backdropImage: json['backdrop_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'backdrop_image': backdropImage,
    };
  }
}


