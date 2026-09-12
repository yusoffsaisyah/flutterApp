class ProductOld {

  final int? id;
  final String title;
  final String thumbnail;
  final String price;

  ProductOld({this.id, required this.title, required this.thumbnail, required this.price});

  factory ProductOld.fromMap(Map<String, dynamic> map){
    return ProductOld(
      id: map['id'] as int,
      title: map['title'] as String,
      thumbnail: map['thumbnail'] as String, 
      price: map['price'] as String,
      );
  }
} 