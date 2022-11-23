import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

import 'contents/bank/bank_no_info_modal.dart';
import 'contents/bank/bank_info_modal.dart';
import './contents/employees/employees.dart';
import './contents/order_report/month_orders_report.dart';

import 'package:snacks_pro_app/views/finance/budget_details.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/orders/orders_cubit.dart';

class FinanceScreen extends StatelessWidget {
  FinanceScreen({Key? key}) : super(key: key);

  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return const HomeFinanceWidget();
    });
  }
}

class HomeFinanceWidget extends StatefulWidget {
  const HomeFinanceWidget({Key? key}) : super(key: key);

  @override
  State<HomeFinanceWidget> createState() => _HomeFinanceWidgetState();
}

class _HomeFinanceWidgetState extends State<HomeFinanceWidget> {
  final modal = AppModal();

  @override
  void initState() {
    context.read<FinanceCubit>().fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar:
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PreferredSize(
                    preferredSize: const Size.fromHeight(70.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          toBeginningOfSentenceCase(DateFormat.MMMM("pt_BR")
                                  .format(DateTime.now()))
                              .toString(),
                          style: AppTextStyles.semiBold(32),
                        ),
                        SvgPicture.asset(
                          "assets/icons/snacks_logo.svg",
                          height: 30,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () => modal.showIOSModalBottomSheet(
                      context: context,
                      content: BlocProvider.value(
                          value: BlocProvider.of<FinanceCubit>(context),
                          child: const BudgetDetailsContent()),
                    ),
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                          // color: Colors.black,
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xffFE5762), Color(0xffFF6BA1)],
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Receita',
                            style:
                                AppTextStyles.regular(15, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          BlocBuilder<FinanceCubit, FinanceHomeState>(
                            builder: (context, state) {
                              return Text(
                                NumberFormat.currency(
                                        locale: "pt", symbol: r"R$ ")
                                    .format(state.budget),
                                style:
                                    AppTextStyles.bold(30, color: Colors.white),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    'Resumo',
                    style: AppTextStyles.semiBold(22),
                  ),
                  const SizedBox(height: 10),
                  CardsSummary(
                    modal: modal,
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Restaurante',
                    style: AppTextStyles.semiBold(22, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingButton(
                      onTap: () {},
                      title: "Stock",
                      description:
                          "Gerencie todo estoque do seu estabelecimento.",
                      icon: Icons.layers_outlined),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(color: Color(0xff4A4A4A)),
                  ),
                  SettingButton(
                      onTap: () => modal.showModalBottomSheet(
                          context: context,
                          content: context
                                  .read<FinanceCubit>()
                                  .state
                                  .bankInfo
                                  .account
                                  .isNotEmpty
                              ? BankInfoModal(
                                  data: context
                                      .read<FinanceCubit>()
                                      .state
                                      .bankInfo,
                                )
                              : const BankNoInfoModal()),
                      title: "Dados bancários",
                      description:
                          "Configure a conta para recebimento da receita.",
                      icon: Icons.attach_money_rounded),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 5),
                  //   child: Divider(color: Color(0xff4A4A4A)),
                  // ),
                  // SettingButton(
                  //     onTap: () {},
                  //     title: "Avaliações",
                  //     description:
                  //         "Observe o que as pessoas estão achando do seu estabelimento.",
                  //     icon: Icons.sentiment_satisfied_rounded),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardsSummary extends StatelessWidget {
  const CardsSummary({
    Key? key,
    required this.modal,
  }) : super(key: key);
  final AppModal modal;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => modal.showIOSModalBottomSheet(
              context: context,
              content: BlocProvider.value(
                  value: BlocProvider.of<OrdersCubit>(context),
                  child: OrdersReportScreen()),
              expand: true),
          child: Container(
            width: 130,
            height: 170,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: const Border.fromBorderSide(BorderSide(width: 2)),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_align_left_rounded),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedidos',
                      style: AppTextStyles.medium(18),
                    ),
                    // BlocBuilder<FinanceCubit, FinanceHomeState>(
                    //   builder: (context, state) {
                    //     return Text(state.orders_count.toString(),
                    //         style: AppTextStyles.bold(18,
                    //             color: Colors.grey.shade400));
                    //   },
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () => modal.showIOSModalBottomSheet(
              context: context,
              content: BlocProvider.value(
                  value: BlocProvider.of<EmployeesCubit>(context),
                  child: const EmployeesContentWidget()),
              expand: true),
          child: Container(
            width: 130,
            height: 170,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: const Border.fromBorderSide(
                //     BorderSide(width: 2)),
                gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xff5CE2FF),
                      Color(0xff0038FF),
                    ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.people_outline_rounded,
                  color: Colors.white,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Funcionários',
                      style: AppTextStyles.medium(18, color: Colors.white),
                    ),

                    // BlocBuilder<EmployeesCubit, EmployeesState>(
                    //   builder: (context, state) {
                    //     return Text(state.amount.toString(),
                    //         style: AppTextStyles.bold(18, color: Colors.white));
                    //   },
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);
  final VoidCallback onTap;
  final String title;
  final String description;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.semiBold(18, color: Colors.white),
                ),
                Text(
                  description,
                  style:
                      AppTextStyles.light(14, color: const Color(0xffB3B3B3)),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Center(child: Icon(icon)),
          )
        ],
      ),
    );
  }
}
