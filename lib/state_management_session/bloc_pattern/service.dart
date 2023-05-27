
class ItemService {
  Future<List<Map<String, dynamic>>> getItemsFromDataSource() {
    // Sample implementation this can be easily replaced with

    return Future.delayed(const Duration(seconds: 3))
        .then((value) => _itemJson);
  }

  static final List<Map<String, dynamic>> _itemJson = [
    {
      "id": 1,
      "name": "Wrist Watch",
      "price": 1000,
      "imgUrl":
          "https://images.pexels.com/photos/2155319/pexels-photo-2155319.jpeg"
    },
    {
      "id": 2,
      "name": "xPhone 1",
      "price": 80000,
      "imgUrl":
          "https://images.pexels.com/photos/2643698/pexels-photo-2643698.jpeg"
    },
    {
      "id": 3,
      "name": "xPhone 2",
      "price": 100000,
      "imgUrl":
          "https://images.pexels.com/photos/209695/pexels-photo-209695.jpeg"
    },
    {
      "id": 4,
      "name": "xPhone 7",
      "price": 90000,
      "imgUrl":
          "https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg"
    },
    {
      "id": 5,
      "name": "xPhone 8",
      "price": 75000,
      "imgUrl":
          "https://images.pexels.com/photos/607815/pexels-photo-607815.jpeg"
    },
    {
      "id": 6,
      "name": "xPhone X",
      "price": 150000,
      "imgUrl":
          "https://images.pexels.com/photos/719399/pexels-photo-719399.jpeg"
    }
  ];
}
