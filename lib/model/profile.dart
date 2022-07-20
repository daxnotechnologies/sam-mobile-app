class Profile {
  String? name;
  String? username;
  int? followers;
  int? following;
  int? reviews;
  int? favourites;
  int? total;
  String? web;
  String? email;
  String?password;
  String imagePath;
  Profile({
    required this.imagePath,
    this.password,
    this.email,
    this.web,
    this.name,
    this.username,
    this.followers,
    this.favourites,
    this.following,
    this.reviews,
    this.total
  });

}