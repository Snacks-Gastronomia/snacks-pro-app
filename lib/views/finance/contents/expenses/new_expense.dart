import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class NewExpenseContent extends StatelessWidget {
  const NewExpenseContent({
    Key? key,
    this.restaurantExpense = false,
    this.restaurantDocId = "",
    this.accessLevel = AppPermission.sadm,
  }) : super(key: key);
  final bool restaurantExpense;
  final String restaurantDocId;
  final AppPermission accessLevel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<FinanceCubit>(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Nova despesa',
                style: AppTextStyles.semiBold(25),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                onChanged: context.read<FinanceCubit>().changeExpenseName,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
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
                  hintText: 'Nome',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                onChanged: context.read<FinanceCubit>().changeExpenseValue,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(signed: true),
                decoration: InputDecoration(
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
                  hintText: 'Value',
                ),
              ),
              if (accessLevel == AppPermission.sadm)
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<FinanceCubit, FinanceHomeState>(
                      builder: (context, state) {
                        return CheckboxListTile(
                          value: state.expenseAUX.sharedValue,
                          onChanged: context
                              .read<FinanceCubit>()
                              .changeExpenseDividerValue,
                          title: Text(
                            "Dividir valor para todos os segmentos",
                            style: AppTextStyles.medium(15),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              CustomSubmitButton(
                  onPressedAction: () => context
                      .read<FinanceCubit>()
                      .saveExpense(context, restaurantExpense),
                  label: "Adicionar depesa"),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: AppTextStyles.medium(14, color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
