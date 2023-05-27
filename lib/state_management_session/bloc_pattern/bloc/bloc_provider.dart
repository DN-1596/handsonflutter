



import 'package:flutter/cupertino.dart';

import 'catalog_bloc.dart';


class BlocProvider extends InheritedWidget {

  final CatalogBloc catalogBloc;

  const BlocProvider({
    super.key,
    required this.catalogBloc,
    required super.child,
  });

  static BlocProvider of(BuildContext context) {
    BlocProvider? blocProvider = context.dependOnInheritedWidgetOfExactType<BlocProvider>();
    assert (blocProvider != null, "BlocProvider not found in the context");
    return blocProvider!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget != this;
  }

}