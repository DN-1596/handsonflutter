

import 'package:flutter/material.dart';
import 'package:handsonflutter/state_management_session/bloc_pattern/bloc/bloc_provider.dart';
import 'package:handsonflutter/state_management_session/bloc_pattern/bloc/catalog_bloc.dart';
import 'package:handsonflutter/state_management_session/bloc_pattern/model/event.dart';
import 'package:handsonflutter/state_management_session/bloc_pattern/model/item.dart';

void runCatalogBlocExample() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Store',
    home: MyHomePage(),
  ));
}


class MyHomePage extends StatelessWidget {

  MyHomePage({Key? key}) : super(key: key);

  final CatalogBloc catalogBloc = CatalogBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      catalogBloc: catalogBloc,
      child: const CatalogPage(),
    );
  }
}




class CatalogPage extends StatefulWidget {


  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late CatalogBloc catalogBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void didChangeDependencies() {
    catalogBloc = BlocProvider.of(context).catalogBloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    catalogBloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Store Catalog'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, size: 24),
                  onPressed: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                  },
                ),
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
                    child: StreamBuilder<int>(
                      stream: catalogBloc.cartCountSink.stream,
                      builder: (context, snapshot) {

                        int cartCount = snapshot.data ?? 0;

                        return Text(
                          cartCount
                              .toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Builder(
          builder: (context) {

            final List<Item> selectedItems = catalogBloc.getSelectedItems();

            if (selectedItems.isEmpty) {
              return NoItemsInCartWidget();
            }

            int totalPrice = selectedItems
                .map((item) => item.price)
                .reduce((value, element) => value + element);

            return Column(
              children: [
                const DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      'Selected Items',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          selectedItems[index].imgUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(selectedItems[index].name),
                        subtitle: Text('\$${selectedItems[index].price}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: StreamBuilder<List<Item>>(
        stream: catalogBloc.itemCatalogSink.stream,
        builder: (context, itemListSnapshot) {

          if (!itemListSnapshot.hasData) {
            catalogBloc.blocEventsSink.add(FetchCatalogDataEvent());
            return loader();
          }

          List<Item> items = itemListSnapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return itemView(items[index]);
            },
          );
        }
      ),
    );
  }

  Widget loader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Please wait, data loading'),
        ],
      ),
    );
  }

  Widget itemView(Item item) {
    return  Container(
      width: MediaQuery.of(context).size.width * 0.5,
      margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Image.network(
          item.imgUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(item.name),
        subtitle: Text('\$${item.price}'),
        trailing: StreamBuilder<List<int>>(
          stream: catalogBloc.selectedItemListSink.stream,
          builder: (context, snapshot) {

            List<int> selectedItems = snapshot.data ?? [];

            bool isItemAlreadyAdded = selectedItems.contains(item.id);

            return ElevatedButton(
              onPressed: () {
                  catalogBloc.blocEventsSink.add(
                    ManipulateCartEvent(
                        itemId: item.id, addItem: !isItemAlreadyAdded),
                  );
                },
              child: isItemAlreadyAdded
                  ? const Text('Remove from cart')
                  : const Text("Add to cart"),
            );
          }
        ),
        onTap: () {
          // Handle tile tap
          print('Tapped on ${item.name}');
        },
      ),
    );
  }

}

class NoItemsInCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'No items in cart',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '😔',
            style: TextStyle(fontSize: 48),
          ),
        ],
      ),
    );
  }
}
