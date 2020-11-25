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

  Map<String, dynamic> toMap() {
    return {'reviews_id': reviewId, 'satisfaction_rating': satisfactionRating, 'entertainment_rating': entertainmentRating, 'interactiveness_rating': interactivenessRating, 'fk_broadcaster_id':broadcasterId , 'fk_user_id':userId};
  }

  Review.fromMap(Map<String, dynamic> m) {
    reviewId = m['reviews_id'];
    satisfactionRating = m['satisfaction_rating'];
    entertainmentRating = m['entertainment_rating'];
    interactivenessRating = m['interactiveness_rating'];
    broadcasterId = m['fk_broadcaster_id'];
    userId = m['fk_user_id'];
  }

}
