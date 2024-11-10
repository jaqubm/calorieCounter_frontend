
import 'package:caloriecounter/models/product.dart';
import 'package:caloriecounter/utils/formatters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoundItemsList extends StatelessWidget{
  bool isLoading;
  List<Product> products;
  FoundItemsList(this.isLoading, this.products);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(
                  Formatters.formatDouble(product.valuesPer) + "g",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  Formatters.formatDouble(product.energy) + " kcal",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                  height: 1,
                  color: const Color.fromARGB(255, 209, 209, 209));
            },
          ),
    );
  }
}