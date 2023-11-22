import 'package:flutter/material.dart';

class DropdownStock extends StatefulWidget {
  const DropdownStock({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  _DropdownStockState createState() => _DropdownStockState();
}

class _DropdownStockState extends State<DropdownStock> {
  String selectedValue = 'L';

  @override
  Widget build(BuildContext context) {
    widget.controller.text = selectedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Medida",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffF7F8F9),
            border: Border.all(color: const Color(0xffE8ECF4), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: DropdownButton<String>(
            isExpanded: true,
            focusColor: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            dropdownColor: const Color(0xffF7F8F9),
            value: selectedValue,
            underline: Container(),
            items: <String>['L', 'kg', 'g', 'un'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
                widget.controller.text = selectedValue;
              });
            },
          ),
        ),
      ],
    );
  }
}
