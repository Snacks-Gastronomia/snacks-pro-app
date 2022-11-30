import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/budget_details.dart';
import 'package:snacks_pro_app/views/finance/contents/Printer/printers.dart';
import 'package:snacks_pro_app/views/finance/contents/expenses/expenses_content.dart';
import 'package:snacks_pro_app/views/finance/contents/restaurants/restaurants_content.dart';
import 'package:snacks_pro_app/views/finance/ratings.dart';
import 'package:snacks_pro_app/views/finance/schedule.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/orders/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

import './contents/employees/employees.dart';
import './contents/order_report/month_orders_report.dart';
import 'contents/bank/bank_info_modal.dart';
import 'contents/bank/bank_no_info_modal.dart';

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

  final admCards = [];
  final restaurantCards = [];

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

                  RestaurantSummaryCards(
                    modal: modal,
                  )
                  // SnacksAdmSummaryCards(
                  //   modal: modal,
                  // )
                ],
              ),
            ),
            SnacksAdmBottomSheet(
              modal: modal,
            )
          ],
        ),
      ),
    );
  }
}

class SnacksAdmBottomSheet extends StatelessWidget {
  const SnacksAdmBottomSheet({
    Key? key,
    required this.modal,
  }) : super(key: key);
  final AppModal modal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Snacks',
          //   style: AppTextStyles.semiBold(22, color: Colors.white),
          // ),

          GradientText(
            "Snacks",
            gradient: const LinearGradient(
                colors: [Color(0xffFE5762), Color(0xffFF6BA1)]),
            style: AppTextStyles.semiBold(22, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          SettingButton(
              onTap: () => modal.showIOSModalBottomSheet(
                  context: context, content: const ScheduleContent()),
              title: "Horário de funcionamento",
              description:
                  "Defina os horários de funcionamento do restaurante.",
              icon: Icons.access_time),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(color: Color(0xff4A4A4A)),
          ),
          // SettingButton(
          //     onTap: () => null,
          //     title: "Transações",
          //     description: "Configure a conta para recebimento da receita.",
          //     icon: Icons.attach_money_rounded),
          // const Padding(
          //   padding: EdgeInsets.symmetric(vertical: 5),
          //   child: Divider(color: Color(0xff4A4A4A)),
          // ),
          SettingButton(
              onTap: () => modal.showIOSModalBottomSheet(
                  context: context, content: RatingsContent()),
              title: "Avaliações",
              description:
                  "Observe o que as pessoas estão achando do seu estabelimento.",
              icon: Icons.sentiment_satisfied_rounded),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}

class RestaurantBottomSheet extends StatelessWidget {
  const RestaurantBottomSheet({
    Key? key,
    required this.modal,
  }) : super(key: key);
  final AppModal modal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientText(
            "Restaurante",
            gradient: const LinearGradient(
                colors: [Color(0xffFE5762), Color(0xffFF6BA1)]),
            style: AppTextStyles.semiBold(22, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          SettingButton(
              onTap: () {},
              title: "Stock",
              description: "Gerencie todo estoque do seu estabelecimento.",
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
                          data: context.read<FinanceCubit>().state.bankInfo,
                        )
                      : const BankNoInfoModal()),
              title: "Dados bancários",
              description: "Configure a conta para recebimento da receita.",
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
    );
  }
}

class CardSummary extends StatelessWidget {
  const CardSummary({
    Key? key,
    required this.title,
    required this.icon,
    this.bgHighlight = false,
    required this.action,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final bool bgHighlight;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: 130,
        height: 170,
        padding: const EdgeInsets.all(20),
        decoration: bgHighlight
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xff5CE2FF),
                      Color(0xff0038FF),
                    ]))
            : BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: const Border.fromBorderSide(BorderSide(width: 2)),
                color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: bgHighlight ? Colors.white : Colors.black,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.medium(17,
                      color: bgHighlight ? Colors.white : Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SnacksAdmSummaryCards extends StatelessWidget {
  SnacksAdmSummaryCards({super.key, required this.modal});
  final AppModal modal;

  final List list = [
    {
      "title": "Despesas",
      "icon": Icons.list,
      "highlight": false,
      "action": const ExpensesContent()
    },
    // {
    //   "title": "Horário",
    //   "icon": Icons.access_time_rounded,
    //   "highlight": true,
    //   "action": null
    // },
    {
      "title": "Restaurantes",
      "icon": Icons.restaurant,
      "highlight": true,
      "action": RestaurantsContent()
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => CardSummary(
              title: list[index]["title"],
              icon: list[index]["icon"],
              bgHighlight: list[index]["highlight"],
              action: () => modal.showIOSModalBottomSheet(
                  context: context,
                  content: list[index]["action"],
                  expand: true)),
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemCount: list.length),
    );

    // Row(
    //   children: [

    //     const SizedBox(width: 15),
    //   ],
    // );
  }
}

class RestaurantSummaryCards extends StatelessWidget {
  RestaurantSummaryCards({
    Key? key,
    required this.modal,
  }) : super(key: key);
  final AppModal modal;

  final List list = [
    {
      "title": "Pedidos",
      "icon": Icons.format_align_left_rounded,
      "highlight": false,
      "action": OrdersReportScreen(),
    },
    {
      "title": "Impressoras",
      "icon": Icons.print,
      "highlight": false,
      "action": const PrinterContent()
    },
    {
      "title": "Funcionários",
      "icon": Icons.people_outline_rounded,
      "highlight": true,
      "action": const EmployeesContentWidget()
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 170,
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => CardSummary(
                title: list[index]["title"],
                icon: list[index]["icon"],
                bgHighlight: list[index]["highlight"],
                action: () => modal.showIOSModalBottomSheet(
                    context: context,
                    content: list[index]["action"],
                    expand: true)),
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemCount: list.length));
    // return Row(
    //   children: [
    //     CardSummary(
    //       title: "Pedidos",
    //       icon: Icons.format_align_left_rounded,
    //       action: () => modal.showIOSModalBottomSheet(
    //           context: context,
    //           content: BlocProvider.value(
    //               value: BlocProvider.of<OrdersCubit>(context),
    //               child: OrdersReportScreen()),
    //           expand: true),
    //     ),
    //     const SizedBox(width: 15),
    //     CardSummary(
    //       title: "Impressoras",
    //       icon: Icons.print,
    //       action: () => modal.showIOSModalBottomSheet(
    //           context: context,
    //           content: BlocProvider.value(
    //               value: BlocProvider.of<EmployeesCubit>(context),
    //               child: const PrinterContent()),
    //           expand: true),
    //     ),
    //     const SizedBox(width: 15),
    //     CardSummary(
    //       title: "Funcionários",
    //       icon: Icons.people_outline_rounded,
    //       action: () => modal.showIOSModalBottomSheet(
    //           context: context,
    //           content: BlocProvider.value(
    //               value: BlocProvider.of<EmployeesCubit>(context),
    //               child: const EmployeesContentWidget()),
    //           expand: true),
    //     ),
    //   ],
    // );
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

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}
