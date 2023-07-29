import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/input_dashed_border.dart';

class DashedBorderSelect extends DashedBorderInput {
  const DashedBorderSelect(
      {super.key,
      required super.label,
      required this.items,
      required super.onChange,
      required super.status,
      super.value});

  final List<String> items;
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<String>(
              value: super.value,
              hint: Text(
                "Selecione",
                style: AppTextStyles.regular(16, color: Colors.black26),
              ),
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: AppTextStyles.medium(16, color: Colors.black54),
              isExpanded: true,
              itemHeight: 55,
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              onChanged: (value) => onChange(value ?? ""),
              borderRadius: BorderRadius.circular(15),
              items: items
                  .map((String value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
            ))
      ],
    );
  }
}
