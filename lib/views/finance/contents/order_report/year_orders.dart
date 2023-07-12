import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/order_report/month_orders_report.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_report.dart';
import 'package:snacks_pro_app/views/recharge_card/state/recharge/recharge_cubit.dart';

class SelectMonthReport extends StatelessWidget {
  SelectMonthReport({
    Key? key,
    required this.restaurant_id,
  }) : super(key: key);

  final String restaurant_id;
  final DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var list = Iterable<int>.generate(dateTime.month).toList();
    print(restaurant_id);
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
                          content: OrdersReportScreen(
                            month: index + 1,
                            restaurant_id: restaurant_id,
                          ),
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
