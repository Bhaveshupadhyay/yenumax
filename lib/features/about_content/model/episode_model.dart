class EpisodeModel {
  final int id;
  final int seasonId;
  final int episodeNumber;
  final String title;
  final String description;
  final String posterImage;
  final int duration;
  final int releaseYear;

  EpisodeModel({
    required this.id,
    required this.seasonId,
    required this.episodeNumber,
    required this.title,
    required this.description,
    required this.posterImage,
    required this.duration,
    required this.releaseYear,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'],
      seasonId: json['season_id'],
      episodeNumber: json['episode_number'],
      title: json['title'],
      description: json['description'],
      posterImage: json['poster_image'],
      duration: json['duration'],
      releaseYear: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season_id': seasonId,
      'episode_number': episodeNumber,
      'title': title,
      'description': description,
      'poster_image': posterImage,
      'duration': duration,
      'release_year': releaseYear,
    };
  }
}
