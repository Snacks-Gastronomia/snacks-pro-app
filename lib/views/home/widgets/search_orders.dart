import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';

class SearchOrders extends StatelessWidget {
  const SearchOrders(
      {super.key, required this.controllerFilter, required this.action});
  final TextEditingController controllerFilter;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.fromLTRB(10, 32, 10, 36),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controllerFilter,
        onChanged: (value) {
          action();
        },
        decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(20)),
      ),
    );
  }
}
