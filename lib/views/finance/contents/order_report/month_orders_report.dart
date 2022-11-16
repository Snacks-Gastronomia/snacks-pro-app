import "package:flutter/material.dart";
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import './day_order_report.dart';

class OrdersReportScreen extends StatelessWidget {
  OrdersReportScreen({Key? key}) : super(key: key);
  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Text(
              'Relatório de pedidos',
              style: AppTextStyles.semiBold(22),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Junho',
              style: AppTextStyles.light(18),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total de pedidos',
                      style: AppTextStyles.regular(16),
                    ),
                    Text('300', style: AppTextStyles.semiBold(32)),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.grey.shade400,
                  height: 50,
                  width: 1,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receita obtida',
                      style: AppTextStyles.regular(16),
                    ),
                    Text(r'R$ 3.000', style: AppTextStyles.semiBold(32)),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .60,
              child: ListView.separated(
                // shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onTap: () => modal.showIOSModalBottomSheet(
                        context: context,
                        content: DayOrdersReportScreen(),
                      ),
                      tileColor: Colors.black,
                      title: Text(
                        '22 de junho',
                        style: AppTextStyles.semiBold(18, color: Colors.white),
                      ),
                      subtitle: Text(
                        r'R$ 2.000',
                        style: AppTextStyles.light(14, color: Colors.white),
                      ),
                      trailing: Text(
                        "25",
                        style: AppTextStyles.semiBold(18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
