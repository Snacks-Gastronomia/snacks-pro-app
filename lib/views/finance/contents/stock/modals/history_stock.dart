import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_consume.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';

class HistoryStock extends StatelessWidget {
  const HistoryStock({super.key, required this.item, this.losses});
  final ItemStock item;
  final bool? losses;

  @override
  Widget build(BuildContext context) {
    final stock = NewStockService();
    String amount = '${item.consume!.toInt()}${item.measure}';

    return Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder(
        future: stock.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                height: 300, child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              children: [
                const ListTile(
                  title: Text(
                    'Histórico de pedidos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.calendar_month),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  trailing: Text(
                    'Total: $amount',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text('Nenhum pedido encontrado.'),
                const SizedBox(
                  height: 25,
                ),
                CustomSubmitButton(
                  onPressedAction: () => Navigator.pop(context),
                  label: 'OK',
                ),
              ],
            );
          } else {
            List processedOrders =
                snapshot.data!.map((doc) => doc.data()['items']).toList();
            List mylist =
                processedOrders.map((order) => order[0]['item']).toList();

            List filteredList = processedOrders.where((order) {
              return order[0]['item']['ingredients'].contains('agua');
            }).toList();
            print('filtered list: ${filteredList}');

            int totalAmount = filteredList.fold<int>(0, (previousValue, order) {
              return previousValue + order[0]['amount'] as int;
            });

            return Column(
              children: [
                const ListTile(
                  title: Text(
                    'Histórico de pedidos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.calendar_month),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  trailing: Text(
                    'Total: $totalAmount',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 350,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      String titleFilter =
                          filteredList[index][0]['item']['title'];
                      int amount = filteredList[index][0]['amount'];
                      var itemConsume =
                          item.items!.firstWhere((e) => e.title == titleFilter);
                      return ListTile(
                        title: Text(titleFilter),
                        subtitle: Text("Quantidade: $amount"),
                        trailing: Text(
                            "${itemConsume.consume * amount}${item.measure}"),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomSubmitButton(
                  onPressedAction: () => Navigator.pop(context),
                  label: 'OK',
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
