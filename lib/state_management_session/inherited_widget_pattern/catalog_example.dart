

import 'package:flutter/material.dart';

void runCatalogExample() {
  runApp(const AppStateWidget(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store',
      home: MyHomePage(),
    ),
  ));
}


class AppStateWidget extends StatefulWidget {

  final Widget child;

  const AppStateWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AppStateWidget> createState() => AppState();


  static AppState of(BuildContext context) {
    final AppState? appState =  context.findAncestorStateOfType<AppState>();
    assert(appState != null, "No App =State found in the context.");
    return appState!;
  }

}

class AppState extends State<AppStateWidget> {

  CatalogData catalogData = CatalogData(selectedItemsIds: []);

  void updateItemCart(Item item, {bool remove = false}) {
    if (remove) {
      if (catalogData.selectedItemsIds.contains(item.id)) {
        List<int> selectedItmIds = catalogData.selectedItemsIds;
        selectedItmIds.remove(item.id);
        setState(() {
          catalogData = catalogData.copyWith(
            selectedItemsIds: selectedItmIds,
          );
        });
      }
      return;
    }

    if (!catalogData.selectedItemsIds.contains(item.id)) {
      List<int> selectedItmIds = catalogData.selectedItemsIds;
      selectedItmIds.add(item.id);
      setState(() {
        catalogData = catalogData.copyWith(
          selectedItemsIds: selectedItmIds,
        );
      });
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return CatalogInheritedWidget(
      catalogData: catalogData,
      child: widget.child,
    );
  }
}

class CatalogInheritedWidget extends InheritedWidget {


  final CatalogData catalogData;

  const CatalogInheritedWidget({
    Key? key,
    required this.catalogData,
    required Widget child,
  }) : super(key: key, child: child);

  static CatalogInheritedWidget of(BuildContext context) {
    final CatalogInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<CatalogInheritedWidget>();
    assert(result != null, 'No CatalogInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CatalogInheritedWidget oldWidget) {
    return oldWidget.catalogData.selectedItemsIds != catalogData.selectedItemsIds;
  }
}

class CatalogData {

  List<Item> catalogItems = [
    Item(name: "Wrist Watch", price: 1000, imgUrl: "imgUrl"),
    Item(name: "xPhone 1", price: 80000, imgUrl: "imgUrl"),
    Item(name: "xPhone 2", price: 100000, imgUrl: "imgUrl"),
    Item(name: "xPhone 7", price: 90000, imgUrl: "imgUrl"),
    Item(name: "xPhone 8", price: 75000, imgUrl: "imgUrl"),
    Item(name: "xPhone X", price: 150000, imgUrl: "imgUrl"),
  ];

  final List<int> selectedItemsIds;

  CatalogData({
    required this.selectedItemsIds,
});

  CatalogData copyWith({
    List<int>? selectedItemsIds,
}) {
    return CatalogData(selectedItemsIds: selectedItemsIds ?? this.selectedItemsIds);
  }

}

class Item {

  static int itemAutoId = 100;

  late int id;
  final String name;
  final int price;
  final String imgUrl;

  Item({
    required this.name,
    required this.price,
    required this.imgUrl,
}) {
    id = itemAutoId++;
  }

}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> catalogItems =
        CatalogInheritedWidget.of(context).catalogData.catalogItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Example'),
        actions: [
          Stack(
            children: [
              const Icon(Icons.shopping_cart),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16.0,
                    minHeight: 16.0,
                  ),
                  child: Text(
                    CatalogInheritedWidget
                        .of(context)
                        .catalogData
                        .selectedItemsIds
                        .length
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: catalogItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final item = catalogItems[index];

          return GridTile(
            child: Column(
              children: [
                Image.network(item.imgUrl),
                const SizedBox(height: 8.0),
                Text(item.name),
                const SizedBox(height: 8.0),
                Text(item.price.toString()),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    AppStateWidget.of(context).updateItemCart(item);
                  },
                  child: const Text('Add to Cart'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
