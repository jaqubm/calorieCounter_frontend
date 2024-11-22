
import 'package:caloriecounter/utils/eatable.dart';
import 'package:caloriecounter/utils/formatters.dart';
import 'package:flutter/material.dart';

class FoundItemsList extends StatelessWidget{
  final bool _isLoading;
  final List<Eatable> _eatables;
  final void Function(Eatable) onItemTap;

  FoundItemsList(this._isLoading, this._eatables, this.onItemTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: _eatables.length,
            itemBuilder: (context, index) {
              final product = _eatables[index];
              return ListTile(
                title: Text(product.getName()),
                subtitle: Text(
                  Formatters.formatDouble(product.getValuePer()) + "g",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  Formatters.formatDouble(product.getEnergy()) + " kcal",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () => onItemTap(product),
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