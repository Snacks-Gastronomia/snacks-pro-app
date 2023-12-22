import 'package:flutter/material.dart';

class DropdownStock extends StatefulWidget {
  const DropdownStock(
      {Key? key, required this.controller, this.initial, this.disable})
      : super(key: key);
  final TextEditingController controller;
  final String? initial;
  final bool? disable;

  @override
  _DropdownStockState createState() => _DropdownStockState();
}

class _DropdownStockState extends State<DropdownStock> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initial ?? 'L';
    widget.controller.text = selectedValue;
  }

  @override
  Widget build(BuildContext context) {
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
          child: IgnorePointer(
            ignoring: widget.disable ?? false,
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
        ),
      ],
    );
  }
}
