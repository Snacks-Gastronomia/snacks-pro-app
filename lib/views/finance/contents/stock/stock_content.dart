import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/stock_card.dart';
import 'package:snacks_pro_app/views/home/widgets/search_orders.dart';

class StockContent extends StatelessWidget {
  StockContent({super.key});

  final TextEditingController controllerFilter = TextEditingController();
  final modal = AppModal();
  NewStockService stockService = NewStockService();

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
        child: StreamBuilder(
          stream: stockService.streamStock(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CustomCircularProgress(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            }

            final docs = snapshot.data?.docs;

            List<ItemStock> itemStockList = (docs ?? []).map((doc) {
              return ItemStock.fromMap(doc.data());
            }).toList();

            return Column(
              children: [
                ListTile(
                  title: Text(
                    "Gerenciamento",
                    style: AppTextStyles.regular(22),
                  ),
                  subtitle: const Text('Selecione um para mais detalhes'),
                ),
                SearchOrders(controllerFilter: controllerFilter, action: () {}),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    itemCount: docs?.length ?? 0,
                    itemBuilder: (context, index) {
                      return StockCard(item: itemStockList[index]);
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
