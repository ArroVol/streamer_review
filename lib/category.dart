/// The category class.
///
/// [position], This class stores the position where the user wants their [category] to be displayed
/// [selected], and whether it was selected to be viewed.
class Category {
  String category;
  String dbTag;
  bool selected;
  // Category(String category, bool selected){
  //   this.category = category;
  //   this.selected = selected;
  // }

  /// Converts the category object to a Json object.
  Category.forJson({
    this.category,
    this.selected,
    this.dbTag,
  });

  ///The constructor for the Category object.
  ///
  /// [selected], whether it was selected to be viewed.
  Category(String category, bool selected, String dbTag){
    this.category = category;
    this.selected = selected;
    this.dbTag = dbTag;

  }

  /// Converts the category jason object.
  factory Category.fromJson(Map<String, dynamic> jsonData) {
    return Category.forJson(
      category: jsonData['category'],
      selected: jsonData['selected'],
      dbTag: jsonData['dbTag'],
    );
  }

  /// Maps the category object ot a dynamic Map.
  static Map<String, dynamic> toMap(Category category) => {
    'category': category.category,
    'selected': category.selected,
    'dbTag': category.dbTag,
  };
}

// class Category {
//   String category;
//   bool selected;
//   int position;
//
//   // Category(String category, bool selected){
//   //   this.category = category;
//   //   this.selected = selected;
//   // }
//
//   Category.forJson({
//    this.category,
//    this.selected,
// });
//
//   Category(String category, bool selected){
//     this.category = category;
//     this.selected = selected;
//
//   }
//
//   factory Category.fromJson(Map<String, dynamic> jsonData) {
//     return Category.forJson(
//       category: jsonData['category'],
//       selected: jsonData['selected'],
//     );
//   }
//
//   static Map<String, dynamic> toMap(Category category) => {
//     'category': category.category,
//     'selected': category.selected,
//   };
// }
