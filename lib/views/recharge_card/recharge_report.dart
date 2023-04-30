import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.images.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class RechargeReportContent extends StatelessWidget {
  const RechargeReportContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var day = context.read<RechargeCubit>().state.day;
    var now = DateTime.now();

    var dmyString = '$day/${now.month}/${now.year}';
    var date = DateFormat('d/M/y').parse(dmyString);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, 170),
          child: Stack(
            children: [
              BlocBuilder<RechargeCubit, RechargeState>(
                builder: (context, state) {
                  return Container(
                    height: 170,
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(30.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Recargas',
                              style: AppTextStyles.regular(16,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              state.recharges.length.toString(),
                              style:
                                  AppTextStyles.bold(30, color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Receita',
                              style: AppTextStyles.regular(16,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              NumberFormat.currency(
                                      locale: "pt", symbol: r"R$ ")
                                  .format(state.totalRechargesValue),
                              style:
                                  AppTextStyles.bold(30, color: Colors.white),
                            ),
                            //   },
                            // ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.yMMMMd('pt_BR').format(date),
                    style: AppTextStyles.light(20),
                  ),
                  BlocBuilder<RechargeCubit, RechargeState>(
                      builder: (context, state) {
                    return PopupMenuButton(
                      icon: const Icon(Icons.tune_rounded),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 10,
                      itemBuilder: (context) {
                        final items = [
                          {"label": "Tudo", "value": ""},
                          {"label": "Pix", "value": "pix"},
                          {"label": "Cartão de crédito", "value": "creditCard"},
                          {"label": "Cartão de débito", "value": "debitCard"},
                          {"label": "Dinheiro", "value": "money"},
                        ];
                        return items
                            .map(
                              (item) => PopupMenuItem(
                                onTap: () {
                                  context
                                      .read<RechargeCubit>()
                                      .changeFilter(item["value"] ?? "");
                                },
                                child: Text(
                                  item["label"] ?? "",
                                  style: AppTextStyles.medium(16,
                                      color: state.filter == item["value"]
                                          ? Colors.blue
                                          : Colors.black54),
                                ),
                              ),
                            )
                            .toList();
                      },
                    );
                  })
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              FutureBuilder<void>(
                  future: context.read<RechargeCubit>().fetchRecharges(),
                  builder: (context, snapshot) {
                    if ((snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.done)) {
                      return BlocBuilder<RechargeCubit, RechargeState>(
                        builder: (context, state) {
                          List data = state.recharges;
                          if (state.status == AppStatus.loading) {
                            return const CustomCircularProgress();
                          }
                          return Expanded(
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 15,
                                    ),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) => CardExpense(
                                    title: data[index]["responsible"],
                                    time: data[index]["created_at"],
                                    value: double.parse(
                                        data[index]["value"].toString()))),
                          );
                        },
                      );
                    }

                    return const CustomCircularProgress();
                  })
            ],
          ),
        )

        // return const Center(
        //   child: SizedBox(
        //     width: 50,
        //     height: 50,
        //     child: CircularProgressIndicator(),
        //   ),
        // );

        // Positioned(
        //   top: 15,
        //   right: 15,
        //   child: IconButton(
        //       onPressed: () => Navigator.pop(context),
        //       icon: const Icon(
        //         Icons.cancel_rounded,
        //         color: Colors.white,
        //         size: 30,
        //       )),
        // ),

        );
  }
}

class CardExpense extends StatelessWidget {
  const CardExpense({
    Key? key,
    required this.title,
    required this.time,
    required this.value,
    this.icon,
  }) : super(key: key);
  final String title;
  final String time;
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
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: const Color(0xffF0F6F5),
                  borderRadius: BorderRadius.circular(8)),
              child: SvgPicture.asset(AppImages.snacks_logo),
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
                  time,
                  style:
                      AppTextStyles.regular(13, color: const Color(0xff666666)),
                ),
              ],
            ),
          ],
        ),
        Text(
          NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value),
          style: AppTextStyles.medium(18, color: const Color(0xff25A969)),
        ),
      ],
    );
  }
}
