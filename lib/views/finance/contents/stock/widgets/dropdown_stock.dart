import 'package:flutter/material.dart';

class DropdownStock extends StatefulWidget {
  const DropdownStock({Key? key}) : super(key: key);

  @override
  _DropdownStockState createState() => _DropdownStockState();
}

class _DropdownStockState extends State<DropdownStock> {
  String selectedValue = 'L'; // Valor inicial selecionado

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF7F8F9),
        border: Border.all(
            color: Color(0xffE8ECF4), width: 1), // Adicionando uma borda
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButton<String>(
        focusColor: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        dropdownColor: Color(0xffF7F8F9),
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
          });
        },
      ),
    );
  }
}
