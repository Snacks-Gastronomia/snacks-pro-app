import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class CustomNumberFieldStock extends StatelessWidget {
  const CustomNumberFieldStock({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: const Color(0xffF7F8F9),
        filled: true,
        hintStyle: AppTextStyles.medium(16,
            color: const Color(0xff8391A1).withOpacity(0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
        label: Text(title),
      ),
    );
  }
}
