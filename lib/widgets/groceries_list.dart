import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  final List<GroceryItem> _groceryItems = [];

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
