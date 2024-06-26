import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_report.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class SelectDayReport extends StatelessWidget {
  const SelectDayReport({super.key, this.month = 0});
  final int month;

  @override
  Widget build(BuildContext context) {
    var dt = month != 0 ? DateTime(0, month) : DateTime.now();

    int daysInMonth(DateTime date) {
      var firstDayThisMonth = DateTime(date.year, date.month, date.day);
      var firstDayNextMonth = DateTime(firstDayThisMonth.year,
          firstDayThisMonth.month + 1, firstDayThisMonth.day);
      return firstDayNextMonth.difference(firstDayThisMonth).inDays;
    }

    var list = Iterable<int>.generate(daysInMonth(dt)).toList();
    var monthStr = DateFormat.MMMM('pt_BR').format(dt);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Relatório de $monthStr',
              style: AppTextStyles.bold(20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  int day = list[index] + 1;
                  return GestureDetector(
                    onTap: () {
                      context.read<RechargeCubit>().changeDay(day);
                      context.read<RechargeCubit>().changeMonth(dt.month);
                      AppModal().showIOSModalBottomSheet(
                          context: context,
                          content: const RechargeReportContent(),
                          expand: true);
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$day de $monthStr',
                            style: AppTextStyles.semiBold(16),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey.shade400,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
