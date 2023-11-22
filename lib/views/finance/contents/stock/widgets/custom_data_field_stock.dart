import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class CustomDataFieldStock extends StatelessWidget {
  const CustomDataFieldStock(
      {super.key, required this.title, required this.controller});
  final String title;
  final TextEditingController controller;

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
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            MaskTextInputFormatter(
              mask: "##/##/####",
              filter: {'#': RegExp(r'[0-9]')},
            )
          ],
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_month),
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
            label: Text('01/01/2023'),
          ),
        ),
      ],
    );
  }
}
