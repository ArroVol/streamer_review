class Category {
  String category;
  bool selected;
  int position;

  // Category(String category, bool selected){
  //   this.category = category;
  //   this.selected = selected;
  // }

  Category.forJson({
   this.category,
   this.selected,
});

  Category(String category, bool selected){
    this.category = category;
    this.selected = selected;

  }

  factory Category.fromJson(Map<String, dynamic> jsonData) {
    return Category.forJson(
      category: jsonData['category'],
      selected: jsonData['selected'],
    );
  }

  static Map<String, dynamic> toMap(Category category) => {
    'category': category.category,
    'selected': category.selected,
  };
}