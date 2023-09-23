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
      height: 200,
      child: Column(children: [
        Row(
          children: [
            Checkbox(
              splashRadius: 10,
              value: value,
              onChanged: (value) {
                value = !value!;
              },
            ),
            const Text('Taxa delivery')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subtotal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("$subtotal")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Delivery',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("$delivery")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("$total")
          ],
        )
      ]),
    );
  }
}
