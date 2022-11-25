import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/expenses/new_expense.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class ExpensesContent extends StatelessWidget {
  const ExpensesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: UniqueKey(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: BlocBuilder<EmployeesCubit, EmployeesState>(
              builder: (context, state) {
            return Column(
              children: [
                Text(
                  'Despesas',
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        // Text(
                        //   'Quantidade',
                        //   style: AppTextStyles.regular(18,
                        //       color: Colors.grey.shade400),
                        // ),
                        BlocBuilder<FinanceCubit, FinanceHomeState>(
                            builder: (context, _) {
                          return Text(
                            context
                                .read<FinanceCubit>()
                                .state
                                .expenses_length
                                .toString(),
                            style: AppTextStyles.bold(32, color: Colors.black),
                          );
                        }),
                      ],
                    ),
                    Container(
                      height: 30,
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    Column(
                      children: [
                        // Text(
                        //   'Total',
                        //   style: AppTextStyles.regular(18,
                        //       color: Colors.grey.shade400),
                        // ),

                        BlocBuilder<FinanceCubit, FinanceHomeState>(
                            builder: (context, _) {
                          return Text(
                            NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                                .format(context
                                    .read<FinanceCubit>()
                                    .state
                                    .expenses_value),
                            style: AppTextStyles.bold(32, color: Colors.black),
                          );
                        }),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const Expanded(child: ListExpenses()),
                TextButton.icon(
                  onPressed: () async {
                    // var cubit = context.read<FinanceCubit>();
                    // var res =
                    await AppModal().showModalBottomSheet(
                        withPadding: false,
                        context: context,
                        content: const NewExpenseContent());

                    // cubit.fetchExpenses();
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    "Adicionar despesa",
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ListExpenses extends StatelessWidget {
  const ListExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<FinanceCubit>().fetchExpensesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<FinanceCubit>().adjustExpenseData(snapshot.data!.docs);
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 15,
                    ),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  return BlocBuilder<FinanceCubit, FinanceHomeState>(
                      builder: (context, state) {
                    return CardExpense(
                        deleteAction: () =>
                            context.read<FinanceCubit>().deleteExpense(item.id),
                        title: item.get("name"),
                        value: double.parse(item.get("value").toString()));
                  });
                });
          }
          return const CustomCircularProgress();
        });
  }
}

class CardExpense extends StatelessWidget {
  const CardExpense({
    Key? key,
    required this.title,
    this.month,
    required this.value,
    this.icon = Icons.pie_chart_outline_rounded,
    required this.deleteAction,
  }) : super(key: key);
  final String title;
  final String? month;
  final double value;
  final IconData? icon;

  final VoidCallback deleteAction;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          CustomSlidableAction(
            onPressed: (context) {},
            autoClose: true,
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IconButton(
                //     onPressed: null,
                //     icon: Icon(
                //       Icons.delete,
                //       color: Color(0xffE20808),
                //     ))

                TextButton(
                  onPressed: deleteAction,
                  child: Text(
                    "Excluir",
                    style: AppTextStyles.light(14, color: Color(0xffE20808)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: Row(
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
                ],
              ),
            ],
          ),
          Text(
            NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value),
            style: AppTextStyles.medium(18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
