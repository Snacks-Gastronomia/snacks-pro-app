import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class BudgetDetailsContent extends StatelessWidget {
  const BudgetDetailsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 170,
                width: double.maxFinite,
                padding: const EdgeInsets.all(30.0),
                decoration: const BoxDecoration(
                  // color: Colors.black,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xffFE5762), Color(0xffFF6BA1)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Receita',
                      style: AppTextStyles.regular(16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    BlocBuilder<FinanceCubit, FinanceHomeState>(
                      builder: (context, state) {
                        return Text(
                          NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                              .format(state.budget),
                          style: AppTextStyles.bold(30, color: Colors.white),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Relatório de receita',
                      style: AppTextStyles.semiBold(22),
                    ),
                    Text(
                      'Agosto',
                      style: AppTextStyles.light(18),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const CardExpense(
                      title: "Receita liquida",
                      month: "Agosto",
                      value: 2.300,
                      icon: Icons.attach_money_rounded,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 15,
                              ),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) => CardExpense(
                              title: "Expense",
                              month: "Agosto",
                              value: ((index + 1) * 100.0) * -1)),
                    )

                    // List.generate(
                    //     3,
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 15,
            right: 15,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.white,
                  size: 30,
                )),
          ),
        ],
      ),
    );
  }
}

class CardExpense extends StatelessWidget {
  const CardExpense({
    Key? key,
    required this.title,
    required this.month,
    required this.value,
    this.icon,
  }) : super(key: key);
  final String title;
  final String month;
  final double value;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: const Color(0xffF0F6F5),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon ?? Icons.pie_chart_outline_rounded),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.medium(16),
                ),
                Text(
                  month,
                  style:
                      AppTextStyles.regular(13, color: const Color(0xff666666)),
                ),
              ],
            ),
          ],
        ),
        Text(
          value < 0 ? '- ${value * -1}' : '+ $value',
          style: AppTextStyles.medium(18,
              color: value < 0
                  ? const Color(0xffF95B51)
                  : const Color(0xff25A969)),
        ),
      ],
    );
  }
}
