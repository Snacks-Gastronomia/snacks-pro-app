import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

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
                      'Receita bruta',
                      style: AppTextStyles.regular(16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    BlocBuilder<FinanceCubit, FinanceHomeState>(
                      builder: (context, state) {
                        var total = context
                                    .read<HomeCubit>()
                                    .state
                                    .storage["access_level"] ==
                                AppPermission.sadm.name
                            ? state.budget
                            : state.budget - state.expenses_value;
                        return Text(
                          NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                              .format(total),
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
                        DateFormat.MMMM("pt_BR").format(DateTime.now()),
                        style: AppTextStyles.light(18),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      CardExpense(
                        title: "Receita líquida",
                        month: DateFormat.MMMM("pt_BR").format(DateTime.now()),
                        value: context.read<FinanceCubit>().state.budget,
                        icon: Icons.attach_money_rounded,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: FutureBuilder(
                            future:
                                context.read<FinanceCubit>().fetchExpenses(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                          height: 15,
                                        ),
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var item = snapshot.data![index];
                                      return CardExpense(
                                          title: item.data()["name"],
                                          value: double.parse(item
                                                  .data()["value"]
                                                  .toString()) *
                                              -1);
                                    });
                              }
                              return const Center(
                                child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      backgroundColor: Colors.black12,
                                    )),
                              );
                            }),
                      )

                      // List.generate(
                      //     3,
                    ],
                  ))
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
    this.month,
    required this.value,
    this.icon = Icons.pie_chart_outline_rounded,
  }) : super(key: key);
  final String title;
  final String? month;
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
              child: Icon(icon),
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
                // Text(
                //   month,
                //   style:
                //       AppTextStyles.regular(13, color: const Color(0xff666666)),
                // ),
              ],
            ),
          ],
        ),
        Text(
          (value < 0 ? '' : '+ ') +
              NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value),
          style: AppTextStyles.medium(18,
              color: value < 0
                  ? const Color(0xffF95B51)
                  : const Color(0xff25A969)),
        ),
      ],
    );
  }
}
