import 'package:flutter/material.dart';

class AddOrderTotal extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;
  const AddOrderTotal({
    super.key,
    required this.subtotal,
    required this.delivery,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    bool value = false;
    return SizedBox(
      width: double.infinity,
      height: double.maxFinite,
      child: Column(children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          secondary: const Text('Taxa delivery'),
          value: value,
          onChanged: (value) {
            value = value!;
          },
        ),
        ListTile(
          title: const Text("Subtotal"),
          trailing: Text("$subtotal"),
        ),
        ListTile(
          title: const Text("Delivery"),
          trailing: Text("$delivery"),
        ),
        ListTile(
          title: const Text("Total"),
          trailing: Text("$total"),
        )
      ]),
    );
  }
}
