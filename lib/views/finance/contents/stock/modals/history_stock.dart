import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
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
      child: Column(
        children: [
          ListTile(
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 350,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text("Quantidade: ${item.amount}"),
                  trailing: Text("${item.amount}${item.measure}"),
                );
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          CustomSubmitButton(
              onPressedAction: () => Navigator.pop(context), label: 'OK')
        ],
      ),
    );
  }
}
