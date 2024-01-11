import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

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
                onChanged: context.read<FinanceCubit>().changeExpenseDocNumber,
                keyboardType: TextInputType.number,
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
                  hintText: 'Número do documento',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                onChanged: context.read<FinanceCubit>().changeExpenseSupplier,
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
                  hintText: 'Fornecedor (opicional)',
                ),
              ),
              const SizedBox(
                height: 10,
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
                  hintText: 'Tipo de despesa',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                onChanged: context.read<FinanceCubit>().changeExpenseValue,
                textInputAction: TextInputAction.next,
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
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
                  hintText: 'Valor',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<FinanceCubit, FinanceHomeState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () async {
                      var result = await showCalendarDatePicker2Dialog(
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            firstDate: DateTime(2022),
                            calendarType: CalendarDatePicker2Type.range),
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                      );

                      String formatDateTime(List<DateTime?>? dateTime) {
                        final DateFormat formatter = DateFormat('dd/MM/yyyy');
                        final String formattedDate1 =
                            formatter.format(dateTime![0]!);
                        final String formattedDate2 =
                            formatter.format(dateTime[1]!);
                        final String formattedDate =
                            "$formattedDate1 - $formattedDate2";
                        return formattedDate;
                      }

                      var dataPeriod = formatDateTime(result);

                      context
                          .read<FinanceCubit>()
                          .changeExpensePeriod(dataPeriod);
                    },
                    child: TextFormField(
                      enabled: false,
                      style: AppTextStyles.medium(16,
                          color: const Color(0xff8391A1)),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.calendar_month),
                        fillColor: const Color(0xffF7F8F9),
                        filled: true,
                        hintStyle: AppTextStyles.medium(16,
                            color: const Color(0xff8391A1).withOpacity(0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: Color(0xffE8ECF4), width: 1)),
                        hintText: state.expenseAUX.period.isEmpty
                            ? 'Período'
                            : state.expenseAUX.period,
                      ),
                    ),
                  );
                },
              ),
              if (accessLevel == AppPermission.sadm)
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<FinanceCubit, FinanceHomeState>(
                      builder: (context, state) {
                        bool value = state.expenseAUX.sharedValue;
                        return CheckboxListTile(
                          value: value,
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
