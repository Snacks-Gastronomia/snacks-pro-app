// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/conference/controllers/conference_controller.dart';

class ModalConference extends StatelessWidget {
  const ModalConference({
    Key? key,
    required this.title,
    required this.controller,
    required this.textEditingController,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final ConferenceController controller;
  final TextEditingController textEditingController;
  final VoidCallback onTap;
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
            'Valor correspondente ao total de pedidos no $title',
          ),
          TextFormField(
            controller: textEditingController,
            style: const TextStyle(fontSize: 52),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              RealInputFormatter(),
            ],
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
