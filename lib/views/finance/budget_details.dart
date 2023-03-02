import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/expenses/expenses_content.dart';
import 'package:snacks_pro_app/views/finance/contents/expenses/new_expense.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/finance/widgets/card_expense.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class BudgetDetailsContent extends StatelessWidget {
  const BudgetDetailsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantID =
        context.read<HomeCubit>().state.storage["restaurant"]["id"];
    final access_level =
        context.read<HomeCubit>().state.storage["access_level"];
    return Scaffold(
      bottomSheet: access_level == AppPermission.radm.name
          ? SizedBox(
              height: 50,
              child: Center(
                child: TextButton(
                  onPressed: () => AppModal().showModalBottomSheet(
                      withPadding: false,
                      context: context,
                      content: NewExpenseContent(
                        restaurantDocId: restaurantID,
                        restaurantExpense: true,
                        accessLevel: access_level.toString().stringToEnum,
                      )),
                  child: const Text('Adicionar depesa adicional'),
                ),
              ),
            )
          : null,
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
                        //  height: MediaQuery.of(context).size.height * 0.40,
                        child: FutureBuilder(
                            future: context
                                .read<FinanceCubit>()
                                .fetchExpenses(restaurantID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return BlocBuilder<FinanceCubit,
                                        FinanceHomeState>(
                                    builder: (context, snapshot) {
                                  var list = snapshot.expensesData;
                                  return ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                            height: 15,
                                          ),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        var item = list[index];
                                        final value = double.parse(item
                                                .data()["value"]
                                                .toString()) *
                                            -1;
                                        return CardExpense(
                                            enableDelete: item.data()["type"] ==
                                                "restaurant",
                                            deleteAction: () => context
                                                .read<FinanceCubit>()
                                                .deleteRestaurantExpense(
                                                    item.id, restaurantID),
                                            title: item.data()["name"],
                                            iconColorBlack: item
                                                    .data()["type"] ==
                                                "restaurant",
                                            value:
                                                (item.data()["sharedValue"] ??
                                                        false)
                                                    ? value /
                                                        snapshot
                                                            .restaurant_count
                                                    : value);
                                      });
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
