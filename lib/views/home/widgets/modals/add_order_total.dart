// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AddOrderTotal extends StatefulWidget {
  final double subtotal;
  final double delivery;
  final double total;
  final ValueChanged<bool> checkBoxValue;
  const AddOrderTotal({
    Key? key,
    required this.subtotal,
    required this.delivery,
    required this.total,
    required this.checkBoxValue,
  }) : super(key: key);

  @override
  State<AddOrderTotal> createState() => _AddOrderTotalState();
}

class _AddOrderTotalState extends State<AddOrderTotal> {
  bool isDelivery = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                shape: const CircleBorder(),
                value: isDelivery,
                onChanged: (value) {
                  setState(() {
                    isDelivery = value!;
                    widget.checkBoxValue(value);
                  });
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
              Text("${widget.subtotal}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${widget.delivery}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${widget.total}")
            ],
          )
        ]),
      ),
    );
  }
}
