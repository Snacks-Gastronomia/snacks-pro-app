// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/views/home/state/add_order_state/add_order_cubit.dart';

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
                  // context.read<AddOrderCubit>().handleCheckboxValue(value);
                });
              },
            ),
            const Text('Taxa delivery')
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${widget.subtotal}")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${widget.delivery}")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${widget.total}")
            ],
          ),
        )
      ]),
    );
  }
}
