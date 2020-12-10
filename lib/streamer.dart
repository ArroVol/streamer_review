
class Streamer {
  String username;
  String description;
  String profilePictureUrl;
  int viewCount;

  // int numberOfFollowers;

  Streamer(String username, String description, String profilePictureUrl,
      int viewCount) {
    this.username = username;
    this.description = description;
    this.profilePictureUrl = profilePictureUrl;
    this.viewCount = viewCount;
    // this.numberOfFollowers = numberOfFollowers;
  }
}
