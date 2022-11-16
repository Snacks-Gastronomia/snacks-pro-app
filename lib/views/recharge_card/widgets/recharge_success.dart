import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class RechargeSuccess extends StatelessWidget {
  const RechargeSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Icon(
            Icons.thumb_up_alt_rounded,
            size: 50,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Recarga realizada com sucesso!',
            textAlign: TextAlign.center,
            style: AppTextStyles.semiBold(22),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomSubmitButton(
              onPressedAction: () => Navigator.pop(context, true),
              label: "Fechar")
        ],
      ),
    );
  }
}
