///
///The class for the broadcasters from the database.
///
class BroadcasterFromDB {
  var overall_satisfaction;
  var overall_skill;
  var overall_entertainment;
  var overall_interactiveness;

  ///Broadcaster from the database constructor.
  ///
  /// [overall_satisfaction], the overall satisfaction of the broadcaster as given by its reviews from users.
  /// [overall_skill], the overall skill of the broadcaster as given by its reviews from users.
  /// [overall_entertainment], the overall entertainment value of the broadcaster as given by its reviews from users.
  /// [overall_interactiveness], the overall interactiveness of the broadcaster as given by its reviews from users.
  BroadcasterFromDB(var overall_satisfaction, var overall_skill,
      var overall_entertainment, var overall_interactiveness) {
    this.overall_satisfaction = overall_satisfaction;
    this.overall_skill = overall_skill;
    this.overall_entertainment = overall_entertainment;
    this.overall_interactiveness = overall_interactiveness;
  }
}
