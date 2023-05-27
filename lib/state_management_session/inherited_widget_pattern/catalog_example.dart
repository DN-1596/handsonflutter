

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
    assert(appState != null, "No App State found in the context.");
    return appState!;
  }

}

class AppState extends State<AppStateWidget> {

  CatalogData catalogData = CatalogData(selectedItemsIds: []);

  void updateItemCart(StoreItem item, {bool remove = false}) {

    List<int> selectedItmIds = [];

    if (remove) {
      if (catalogData.selectedItemsIds.contains(item.id)) {
        selectedItmIds
          ..addAll(catalogData.selectedItemsIds)
          ..remove(item.id);
        setState(() {
          catalogData = catalogData.copyWith(
            selectedItemsIds: selectedItmIds,
          );
        });
      }
      return;
    }

    if (!catalogData.selectedItemsIds.contains(item.id)) {
      selectedItmIds
        ..addAll(catalogData.selectedItemsIds)
        ..add(item.id);
      setState(() {
        catalogData = catalogData.copyWith(
          selectedItemsIds: selectedItmIds,
        );
      });
      return;
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
    return oldWidget != this;
  }
}

class CatalogData {

  List<StoreItem> catalogItems = [
    StoreItem(id: 1,name: "Wrist Watch", price: 1000, imgUrl: "https://images.pexels.com/photos/2155319/pexels-photo-2155319.jpeg"),
    StoreItem(id: 2,name: "xPhone 1", price: 80000, imgUrl: "https://images.pexels.com/photos/2643698/pexels-photo-2643698.jpeg"),
    StoreItem(id: 3,name: "xPhone 2", price: 100000, imgUrl: "https://images.pexels.com/photos/209695/pexels-photo-209695.jpeg"),
    StoreItem(id: 4,name: "xPhone 7", price: 90000, imgUrl: "https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg"),
    StoreItem(id: 5,name: "xPhone 8", price: 75000, imgUrl: "https://images.pexels.com/photos/607815/pexels-photo-607815.jpeg"),
    StoreItem(id: 6,name: "xPhone X", price: 150000, imgUrl: "https://images.pexels.com/photos/719399/pexels-photo-719399.jpeg"),
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

class StoreItem {

  static int itemAutoId = 100;

  late int id;
  final String name;
  final int price;
  final String imgUrl;

  StoreItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imgUrl,
});

}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatalogData catalogData =
        CatalogInheritedWidget.of(context).catalogData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Example'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                const Icon(Icons.shopping_cart,size: 24,),
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
                      catalogData
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
          ),
        ],
      ),
      body: ListView.builder(
        key: UniqueKey(),
        padding: const EdgeInsets.all(16.0),
        itemCount: catalogData.catalogItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemWidget(
            item: catalogData.catalogItems[index],
          );
        },
      ),
    );
  }
}

class ItemWidget extends StatefulWidget {

  final StoreItem item;

  const ItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {

  bool isInCart = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (CatalogInheritedWidget.of(context)
        .catalogData.selectedItemsIds
        .contains(widget.item.id)) {
         isInCart = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    String buttonTitle = isInCart ? "Remove from cart" : "Add to cart";

    return SizedBox(
      key: UniqueKey(),
      width: MediaQuery.of(context).size.width * (0.4),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.item.imgUrl,
                height: MediaQuery.of(context).size.width * (0.2),
                width: MediaQuery.of(context).size.width * (0.2),
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(widget.item.name),
            const SizedBox(height: 8.0),
            Text("\$ " + widget.item.price.toString()),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                AppStateWidget.of(context).updateItemCart(
                  widget.item,
                  remove: isInCart,
                );
              },
              child: Text(buttonTitle),
            ),
          ],
        ),
      ),
    );
  }
}

