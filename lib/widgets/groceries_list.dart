import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_items.dart';

class GroceriesList extends StatelessWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries')),
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
