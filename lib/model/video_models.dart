class Video {
  final String ?id;
  final String ?title;
  final String ?description;
  final String ?thumbnailUrl;
  final String ?channelTitle;
  final String ?publishedAt;

  Video({
    this.id,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.channelTitle,
    this.publishedAt,
  });

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
      publishedAt: snippet['publishedAt'],
    );
  }
}