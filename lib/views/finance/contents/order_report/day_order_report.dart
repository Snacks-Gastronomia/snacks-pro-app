import "package:flutter/material.dart";
import 'package:snacks_pro_app/core/app.text.dart';

class DayOrdersReportScreen extends StatelessWidget {
  const DayOrdersReportScreen({Key? key}) : super(key: key);

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
              '22 de Junho',
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
              height: MediaQuery.of(context).size.height * .6,
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade300),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      title: Text(
                        'Cartão de crédito',
                        style: AppTextStyles.semiBold(16),
                      ),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Text(
                              '1 Coca-cola zero',
                              style: AppTextStyles.light(14,
                                  color: Color(0xffB3B3B3)),
                            ),
                          )
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            r"R$ 22,00",
                            style: AppTextStyles.semiBold(18,
                                color: Color(0xff00B907)),
                          ),
                          Text(
                            '15:56',
                            style: AppTextStyles.light(14),
                          ),
                        ],
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
