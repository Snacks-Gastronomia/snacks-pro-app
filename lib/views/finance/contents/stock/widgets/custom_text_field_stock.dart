import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class CustomTextFieldStock extends StatelessWidget {
  const CustomTextFieldStock(
      {super.key,
      required this.title,
      this.isDescription,
      required this.controller,
      required this.hint});
  final String title;
  final String hint;
  final TextEditingController controller;
  final bool? isDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: controller,
          maxLines: isDescription ?? false ? null : 1,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: const Color(0xffF7F8F9),
            filled: true,
            hintStyle: AppTextStyles.medium(16,
                color: const Color(0xff8391A1).withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xffE8ECF4), width: 1)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xffE8ECF4), width: 1)),
          ),
        ),
      ],
    );
  }
}
