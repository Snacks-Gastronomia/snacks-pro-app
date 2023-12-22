import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';

class DashedBorderInput extends StatelessWidget {
  const DashedBorderInput({
    Key? key,
    required this.label,
    required this.onChange,
    this.value,
    this.keyboardType,
    this.inputFormatters,
    required this.status,
    this.initialValue,
    this.doneButton = false,
  }) : super(key: key);

  final String label;
  final void Function(String) onChange;
  final bool doneButton;
  final String? value;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final AppStatus status;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.medium(18),
        ),
        const SizedBox(
          height: 10,
        ),
        DottedBorder(
          color: Colors.grey,
          strokeWidth: 1.5,
          dashPattern: const [7, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          child: TextFormField(
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            controller: null,
            textInputAction:
                doneButton ? TextInputAction.done : TextInputAction.next,
            onChanged: onChange,
            initialValue: initialValue,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(0),
              ),
              hintText: "Ex.: 5",
            ),
          ),
        ),
      ],
    );
  }
}
