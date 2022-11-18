import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.images.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class RechargeReportContent extends StatelessWidget {
  const RechargeReportContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
              future: context.read<RechargeCubit>().fetchRecharges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List data = snapshot.data!;

                  var total = data.isEmpty
                      ? 0
                      : data.map((e) => e["value"]).reduce((a, b) => a + b);
                  print(data);
                  return Column(
                    children: [
                      Container(
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
                                  data.length.toString(),
                                  style: AppTextStyles.bold(30,
                                      color: Colors.white),
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
                                // BlocBuilder<FinanceCubit, FinanceHomeState>(
                                //   builder: (context, state) {
                                //     return
                                Text(
                                  NumberFormat.currency(
                                          locale: "pt", symbol: r"R$ ")
                                      .format(total),
                                  style: AppTextStyles.bold(30,
                                      color: Colors.white),
                                ),
                                //   },
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Text(
                              DateFormat.yMMMMd('pt_BR').format(DateTime.now()),
                              style: AppTextStyles.light(20),
                            ),
                            const SizedBox(
                              height: 35,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.52,
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 15,
                                      ),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) => CardExpense(
                                      title: data[index]["responsible"],
                                      time: data[index]["created_at"],
                                      value: data[index]["value"])),
                            )

                            // List.generate(
                            //     3,
                          ],
                        ),
                      )
                    ],
                  );
                }
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
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
