


class Item {
  final int id;
  final String name;
  final int price;
  final String imgUrl;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imgUrl: json['imgUrl'],
    );
  }
}