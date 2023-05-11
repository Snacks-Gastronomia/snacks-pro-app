import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class ModalPaymentMethod extends StatelessWidget {
  const ModalPaymentMethod({
    Key? key,
    required this.next,
  }) : super(key: key);
  final VoidCallback next;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<FinanceCubit>(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Selecione a forma de pagamento',
                style: AppTextStyles.semiBold(25),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<RechargeCubit, RechargeState>(
                  builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: const Border.fromBorderSide(
                        BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  ),
                  child: DropdownButton<String>(
                    value: snapshot.method,
                    hint: Text(
                      "MÉTODO DE PAGAMENTO",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular(16, color: Colors.black26),
                    ),
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.grey.shade400,
                    ),
                    elevation: 16,
                    style: AppTextStyles.medium(16, color: Colors.black54),
                    isExpanded: true,
                    itemHeight: 60,
                    underline: Container(
                      height: 2,
                      color: Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    onChanged: (String? value) =>
                        BlocProvider.of<RechargeCubit>(context)
                            .changePaymentMethod(value),
                    borderRadius: BorderRadius.circular(15),
                    items: [
                      {"label": "Pix", "value": "pix"},
                      {"label": "Cartão de crédito", "value": "creditCard"},
                      {"label": "Cartão de débito", "value": "debitCard"},
                      {"label": "Dinheiro", "value": "money"},
                    ]
                        .map((item) => DropdownMenuItem(
                              value: item["value"],
                              child: Text(item["label"] ?? ""),
                            ))
                        .toList(),
                  ),
                );
              }),
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<FinanceCubit, FinanceHomeState>(
                  builder: (context, state) {
                return CustomSubmitButton(
                  onPressedAction: next,
                  label: "Recarregar",
                );
              }),
              // const SizedBox(
              //   height: 10,
              // ),
              // TextButton(
              //   onPressed: () {
              //     context.read<FinanceCubit>().clearAUX();
              //     Navigator.pop(context);
              //   },
              //   child: Text(
              //     "Cancelar",
              //     style: AppTextStyles.medium(16, color: Colors.black),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
