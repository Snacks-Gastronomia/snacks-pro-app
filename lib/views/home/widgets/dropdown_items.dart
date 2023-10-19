// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/models/order_response.dart';

class DropdownItems extends StatelessWidget {
  final dropValue = ValueNotifier('');
  List<String> items;

  DropdownItems({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dropValue,
        builder: (context, String value, _) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                isExpanded: true,
                hint: const Text("Todos os itens"),
                value: (value.isEmpty) ? null : value,
                onChanged: (option) => dropValue.value = option.toString(),
                items: items
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        });
  }
}
