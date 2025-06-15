import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'shopping-list-77450-default-rtdb.europe-west1.firebasedatabase.app',
      'shopping-list.json',
    );

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later.';
      });
    }

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final itemProperties = item.value;
      final category = categories.entries
          .firstWhere(
            (catItem) =>
                catItem.value.categoryName ==
                itemProperties['category'],
          )
          .value;

      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: itemProperties['name'],
          quantity: itemProperties['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(builder: (ctx) => NewItem()),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem grocery) {
    setState(() {
      _groceryItems.remove(grocery);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('You got no items yet'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          final grocery = _groceryItems[index];

          return Dismissible(
            key: ValueKey(grocery.id),
            onDismissed: (direction) {
              _removeItem(grocery);
            },
            child: ListTile(
              title: Text(grocery.name),
              leading: Container(
                height: 24,
                width: 24,
                color: grocery.category.color,
              ),
              trailing: Text('${grocery.quantity}'),
            ),
          );
        },
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addItem, icon: Icon(Icons.add)),
        ],
      ),
      body: content,
    );
  }
}
