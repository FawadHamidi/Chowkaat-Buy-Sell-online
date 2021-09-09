class Category {
  String? name;
  String? iconUrl;
  int? id;
  List<dynamic>? subCategory;

  Category.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    iconUrl = data['icon'];
    id = data['id'];
    subCategory = data['subCategory'];
  }
}
