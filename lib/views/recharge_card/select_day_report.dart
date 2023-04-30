import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_report.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class SelectDayReport extends StatelessWidget {
  SelectDayReport({super.key});
  final DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var list = Iterable<int>.generate(dateTime.day).toList();
    var month = DateFormat.MMMM('pt_BR').format(DateTime.now());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Relatório de $month',
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
                      AppModal().showIOSModalBottomSheet(
                          context: context,
                          content: const RechargeReportContent(),
                          expand: true);
                    },
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$day de $month',
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
