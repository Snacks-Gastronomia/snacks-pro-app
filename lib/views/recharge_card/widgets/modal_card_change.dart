import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class CardChangeModal extends StatelessWidget {
  const CardChangeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Dinheiro a ser estornado ao cliente:',
            textAlign: TextAlign.center,
            style: AppTextStyles.semiBold(20),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<RechargeCubit, RechargeState>(builder: (context, state) {
            return Text(
              NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                  .format(state.value),
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold(30),
            );
          }),
          const SizedBox(
            height: 20,
          ),
          CustomSubmitButton(
              onPressedAction: () => Navigator.pop(context, true),
              label: "Feito")
        ],
      ),
    );
  }
}
