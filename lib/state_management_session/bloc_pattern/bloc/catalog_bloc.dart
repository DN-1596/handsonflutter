



import 'dart:async';

import 'package:handsonflutter/state_management_session/bloc_pattern/model/event.dart';
import 'package:handsonflutter/state_management_session/bloc_pattern/model/item.dart';
import 'package:handsonflutter/state_management_session/bloc_pattern/service.dart';



/// This bloc will keep track of
/// -- selected items
/// -- totalItems in the catalog.
/// -- cart count
/// -- add item to cart event
/// -- delete item from cart event.

class CatalogBloc {

  final ItemService itemService = ItemService();

  /// INPUTS
  final StreamController<BlocEvent> blocEventsSink = StreamController<BlocEvent>.broadcast();

  /// OUTPUTS

  final Map<int,Item> _itemCatalog = {};
  final StreamController<List<Item>> itemCatalogSink = StreamController<List<Item>>();

  final List<int> _selectedItems = [];
  final StreamController<List<int>> selectedItemListSink = StreamController<List<int>>.broadcast();

  final StreamController<int> cartCountSink = StreamController<int>();


  /// the [..] operator is used to here chain the [where] methods

  CatalogBloc() {
    blocEventsSink.stream
        ..where((event) => event is ManipulateCartEvent).listen(_handleAddToCartEvent)
        ..where((event) => event is FetchCatalogDataEvent).listen(_handleFetchCatalogDataEvent);
  }

  void _handleAddToCartEvent(BlocEvent event) {

    if(event is! ManipulateCartEvent) {
      return;
    }

    if (event.addItem && !_selectedItems.contains(event.itemId)) {
      _selectedItems.add(event.itemId);
      selectedItemListSink.add(_selectedItems);
    } else {
      _selectedItems.remove(event.itemId);
      selectedItemListSink.add(_selectedItems);
    }

    cartCountSink.add(_selectedItems.length);

  }


  /// Note: The processing of data is also
  /// handled by the bloc

  void _handleFetchCatalogDataEvent(BlocEvent event) async {
    if (event is! FetchCatalogDataEvent) {
      return;
    }

    List<Map<String,dynamic>> itemJson = await itemService.getItemsFromDataSource();

    for (var json in itemJson) {
      Item item = Item.fromJson(json);
      _itemCatalog.putIfAbsent(item.id, () => item);
    }

    itemCatalogSink.add(_itemCatalog.values.toList());

  }

  Item? getItemById(int id) {
    return _itemCatalog[id];
  }

  List<Item> getSelectedItems() {
    final List<Item> selectedItems = [];
    for (int id in _selectedItems) {
      selectedItems.add(getItemById(id)!);
    }

    return selectedItems;
  }

  dispose() {
    blocEventsSink.close();
    selectedItemListSink.close();
    cartCountSink.close();
    itemCatalogSink.close();
  }




}