import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/order_report/month_orders_report.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_report.dart';
import 'package:snacks_pro_app/views/recharge_card/select_day_report.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class SelectMonthRechargeReport extends StatelessWidget {
  SelectMonthRechargeReport({Key? key}) : super(key: key);

  final DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var list = Iterable<int>.generate(dateTime.month).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Relatório de pedidos ${dateTime.year}',
              style: AppTextStyles.bold(20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var monthDt = DateTime(0, index + 1);
                  var month = DateFormat.MMMM('pt_BR').format(monthDt);

                  return GestureDetector(
                    onTap: () {
                      AppModal().showIOSModalBottomSheet(
                          context: context,
                          content: SelectDayReport(month: index + 1),
                          expand: true);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: const Color(0xffd4d4d4).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            toBeginningOfSentenceCase(month).toString(),
                            style: AppTextStyles.semiBold(16),
                          ),
                          Icon(
                            Icons.calendar_month,
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
