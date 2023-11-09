import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/items_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/stock_card.dart';
import 'package:snacks_pro_app/views/home/widgets/search_orders.dart';

class StockContent extends StatelessWidget {
  StockContent({super.key});

  final TextEditingController controllerFilter = TextEditingController();
  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            modal.showModalBottomSheet(context: context, content: AddStock()),
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "Gerenciamento",
                style: AppTextStyles.regular(22),
              ),
              subtitle: Text('Selecione um para mais detalhes'),
            ),
            SearchOrders(controllerFilter: controllerFilter, action: () {}),
            StockCard(
              item: ItemsStock(
                document: 00010010,
                title: 'Carne Bovina',
                dateTime: DateTime.now(),
                measure: 'kg',
                amount: 100,
                value: 200,
                description: "klansdlkasn aklshdkasljd kajshdlkasd askldhaklsd",
              ),
            )
          ],
        ),
      ),
    );
  }
}
