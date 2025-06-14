import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceriesList extends StatefulWidget {
  const GroceriesList({super.key});

  @override
  State<GroceriesList> createState() => _GroceriesListState();
}

class _GroceriesListState extends State<GroceriesList> {
  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => NewItem()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: _addItem, icon: Icon(Icons.add)),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) {
          final grocery = groceryItems[index];

          return ListTile(
            title: Text(grocery.name),
            leading: Container(
              height: 24,
              width: 24,
              color: grocery.category.color,
            ),
            trailing: Text('${grocery.quantity}'),
          );
        },
      ),
    );
  }
}
