class ContentModel {
  final int id;
  final String title;
  final String description;
  final String posterImage;
  final String backdropImage;
  final String titleImage;
  final int createdAt;
  final String averageRating;
  final int categoryId;
  final List<dynamic> genres;
  final String age;
  final bool inWatchlist;

  ContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterImage,
    required this.backdropImage,
    required this.titleImage,
    required this.createdAt,
    required this.averageRating,
    required this.categoryId,
    required this.genres,
    required this.age,
    required this.inWatchlist,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      posterImage: json['poster_image'],
      backdropImage: json['backdrop_image'],
      titleImage: json['title_image'],
      createdAt: json['created_at'],
      averageRating: json['average_rating'],
      categoryId: json['category_id'],
      genres: json['genres'],
      age: json['age'],
      inWatchlist: json['inWatchlist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'poster_image': posterImage,
      'backdrop_image': backdropImage,
      'title_image': titleImage,
      'created_at': createdAt,
      'average_rating': averageRating,
      'category_id': categoryId,
      'genres': genres,
      'age': age,
      'inWatchlist': inWatchlist,
    };
  }
}
