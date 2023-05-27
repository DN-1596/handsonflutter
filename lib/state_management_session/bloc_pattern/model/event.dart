




abstract class BlocEvent {}


class ManipulateCartEvent extends BlocEvent {
  final int itemId;
  final bool addItem;

  ManipulateCartEvent({
    required this.itemId,
    required this.addItem,
  });
}

class FetchCatalogDataEvent  implements BlocEvent {}