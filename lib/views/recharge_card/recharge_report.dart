import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.images.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class RechargeReportContent extends StatelessWidget {
  const RechargeReportContent({Key? key}) : super(key: key);

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
                          style: AppTextStyles.regular(16, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "35",
                          style: AppTextStyles.bold(30, color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Receita',
                          style: AppTextStyles.regular(16, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        // BlocBuilder<FinanceCubit, FinanceHomeState>(
                        //   builder: (context, state) {
                        //     return
                        Text(
                          NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                              .format(2000),
                          style: AppTextStyles.bold(30, color: Colors.white),
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
                      '22 de agosto de 2022',
                      style: AppTextStyles.light(20),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.52,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 15,
                              ),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 8,
                          itemBuilder: (context, index) => CardExpense(
                              title: "José da silva",
                              time: "15:56",
                              value: (index + 1) * 100.0)),
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
