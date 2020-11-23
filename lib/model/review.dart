class Review {
  int reviewId;
  int satisfactionRating;
  int entertainmentRating;
  int interactivenessRating;
  int broadcasterId;
  int userId;

  static const String TABLENAME = "reviews";

  Review(
      {this.reviewId, this.satisfactionRating, this.entertainmentRating, this.interactivenessRating, this.broadcasterId, this.userId});

  // Map<String, dynamic> toMap() {
  //   return {'_id': id, 'email': email, 'password': password, 'phone_number': phoneNumber, 'user_name':userName};
  // }
  //
  // Review.fromMap(Map<String, dynamic> m) {
  //   id = m['_id'];
  //   email = m['email'];
  //   password = m['password'];
  //   phoneNumber = m['phone_number'];
  //   userName = m['user_name'];
  // }

// satisfaction_rating INTEGER,
//     entertainment_rating INTEGER,
// interactiveness_rating INTEGER,
//     skill_rating INTEGER,
// fk_broadcaster_id INTEGER,
//     fk_user_id INTEGER,
}
