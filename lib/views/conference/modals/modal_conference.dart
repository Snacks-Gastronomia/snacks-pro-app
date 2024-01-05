import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class ModalConference extends StatelessWidget {
  const ModalConference({
    Key? key,
    required this.title,
    required this.textEditingController,
    required this.onTap,
    required this.subtitle,
  }) : super(key: key);

  final String title;
  final TextEditingController textEditingController;
  final VoidCallback onTap;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.semiBold(26),
          ),
          Text(
            subtitle,
          ),
          TextFormField(
            controller: textEditingController,
            style: const TextStyle(fontSize: 52),
            inputFormatters: const [],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'R\$ 0,00',
            ),
          ),
          CustomSubmitButton(
            label: 'Adicionar',
            onPressedAction: () {
              onTap();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
