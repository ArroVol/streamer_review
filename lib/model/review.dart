/// The class for the reviews created by the user for a broadcaster
///
/// @version 1.0
class Review {
  int reviewId;
  int satisfactionRating;
  int entertainmentRating;
  int interactivenessRating;
  int broadcasterId;
  int userId;

  static const String TABLENAME = "reviews";

  /// The review constructor
  ///
  /// [reviewId], the primary key id for the review.
  /// [satisfactionRating], the primary key id for the review.
  /// [entertainmentRating], the primary key id for the review.
  /// [interactivenessRating], the primary key id for the review.
  /// [broadcasterId], the primary key id for the review.
  /// [userId], the primary key id for the review.
  Review(
      {this.reviewId, this.satisfactionRating, this.entertainmentRating, this.interactivenessRating, this.broadcasterId, this.userId});

  /// Maps the review object to a map object.
  Map<String, dynamic> toMap() {
    return {'reviews_id': reviewId, 'satisfaction_rating': satisfactionRating, 'entertainment_rating': entertainmentRating, 'interactiveness_rating': interactivenessRating, 'fk_broadcaster_id':broadcasterId , 'fk_user_id':userId};
  }

  /// Maps the review object to a map object.
  Review.fromMap(Map<String, dynamic> m) {
    reviewId = m['reviews_id'];
    satisfactionRating = m['satisfaction_rating'];
    entertainmentRating = m['entertainment_rating'];
    interactivenessRating = m['interactiveness_rating'];
    broadcasterId = m['fk_broadcaster_id'];
    userId = m['fk_user_id'];
  }

}
