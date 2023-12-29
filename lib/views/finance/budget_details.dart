import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/expenses/new_expense.dart';
import 'package:snacks_pro_app/views/finance/contents/order_report/report.dart';

import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/finance/widgets/card_expense.dart';

class BudgetDetailsContent extends StatelessWidget {
  const BudgetDetailsContent({Key? key}) : super(key: key);
  static final storage = AppStorage();
  static final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.getDataStorage("user"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = snapshot.data ?? {};
            final restaurantID = user["restaurant"]["id"];
            final accessLevel = user["access_level"];

            return Scaffold(
              // bottomSheet:
              appBar: PreferredSize(
                  preferredSize: const Size(double.maxFinite, 170),
                  child: Stack(
                    children: [
                      Container(
                        height: 170,
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(30.0),
                        decoration: const BoxDecoration(
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
                              style: AppTextStyles.regular(16,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            BlocBuilder<FinanceCubit, FinanceHomeState>(
                              builder: (context, state) {
                                var total = state.budget;
                                return Text(
                                  state.status == AppStatus.loading &&
                                          total == 0
                                      ? "Calculando..."
                                      : NumberFormat.currency(
                                              locale: "pt", symbol: r"R$ ")
                                          .format(total),
                                  style: AppTextStyles.bold(30,
                                      color: Colors.white),
                                );
                              },
                            ),
                          ],
                        ),
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
                  )),
              body: DefaultTabController(
                length: 2,
                child: Padding(
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
                        height: 20,
                      ),
                      CardExpenseContent(
                        iconColorBlack: false,
                        title: "Receita líquida",
                        subtitle: DateFormat.MMMM().format(DateTime.now()),
                        month: DateFormat.MMMM("pt_BR").format(DateTime.now()),
                        value: context.read<FinanceCubit>().state.budget -
                            context.read<FinanceCubit>().state.expenses_value,
                        icon: Icons.attach_money_rounded,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (accessLevel == AppPermission.sadm.name)
                          ? Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: TabBar(
                                      indicator: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.black,
                                      tabs: const [
                                        Tab(
                                          height: 30,
                                          text: 'Despesas',
                                        ),
                                        Tab(
                                          text: 'Restaurantes',
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        ExpensesTab(
                                            access_level: accessLevel,
                                            restaurantID: restaurantID),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: ListRestaurantsProfits(
                                              modal: modal),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Expanded(
                              child: ExpensesTab(
                                  access_level: accessLevel,
                                  restaurantID: restaurantID),
                            ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const CustomCircularProgress();
        });
  }
}

class ExpensesTab extends StatelessWidget {
  const ExpensesTab(
      {super.key, required this.access_level, required this.restaurantID});
  final access_level;
  final restaurantID;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          ListAllExpenses(
              access_level: access_level, restaurantID: restaurantID),
          if (access_level == AppPermission.radm.name)
            SizedBox(
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
            ),
        ],
      ),
    );
  }
}

class RestaurantsTab extends StatelessWidget {
  const RestaurantsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ListAllExpenses extends StatelessWidget {
  const ListAllExpenses({
    Key? key,
    required this.access_level,
    required this.restaurantID,
  }) : super(key: key);
  final String access_level;
  final String restaurantID;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
            .read<FinanceCubit>()
            .fetchExpenses(access_level, restaurantID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocBuilder<FinanceCubit, FinanceHomeState>(
                builder: (context, state) {
              var list = state.expensesData;
              // print(list.length);
              return Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var item = list[index];
                      final value =
                          double.parse(item.data()["value"].toString()) * -1;
                      return CardExpense(
                          docNumber: item.data()["docNumber"] ?? 0,
                          supplier: item.data()["supplier"] ?? '',
                          period: item.data()["period"] ?? '',
                          enableDelete: item.data()["type"] == "restaurant",
                          deleteAction: () => context
                              .read<FinanceCubit>()
                              .deleteRestaurantExpense(item.id, restaurantID),
                          title: item.data()["name"],
                          subtitle: item.data()["period"] ?? '',
                          iconColorBlack: item.data()["type"] == "restaurant",
                          icon: (item.data()["sharedValue"] ?? false)
                              ? Icons.groups
                              : null,
                          value: (item.data()["sharedValue"] ?? false) &&
                                  access_level == AppPermission.radm.name
                              ? value / state.restaurant_count
                              : value);
                    }),
              );
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
        });
  }
}

class ListRestaurantsProfits extends StatelessWidget {
  const ListRestaurantsProfits({super.key, required this.modal});
  final modal;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<FinanceCubit>().fetchRestaurantsProfits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocBuilder<FinanceCubit, FinanceHomeState>(
                builder: (context, state) {
              var list = snapshot.data ?? [];

              return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                  shrinkWrap: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    var item = list[index];

                    final value = double.parse(item["total"].toString());

                    return GestureDetector(
                      onTap: () {
                        modal.showIOSModalBottomSheet(
                            context: context,
                            content: ReportScreen(restaurant_id: item["id"]),
                            expand: true);
                      },
                      child: CardExpense(
                          docNumber: item["docNumber"] ?? 0,
                          supplier: item["supplier"] ?? "",
                          period: item["period"] ?? '',
                          enableDelete: false,
                          deleteAction: null,
                          title: item["name"],
                          subtitle: "",
                          icon: Icons.restaurant,
                          iconColorBlack: true,
                          value: value),
                    );
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
        });
  }
}
