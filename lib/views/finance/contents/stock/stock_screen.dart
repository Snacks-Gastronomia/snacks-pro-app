import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/stock_card.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';

class StockScreen extends StatelessWidget {
  StockScreen({super.key});

  final TextEditingController controllerFilter = TextEditingController();
  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => modal.showModalBottomSheet(
              context: context,
              content: const AddDataToStock(
                typeModal: StockModalOptions.isNew,
              )),
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: context.read<StockCubit>().fetchStockItems(),
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

              final docs = snapshot.data?.docs ?? [];

              return Column(
                children: [
                  ListTile(
                    title: Text(
                      "Gerenciamento",
                      style: AppTextStyles.regular(22),
                    ),
                    subtitle: const Text('Selecione um para mais detalhes'),
                  ),
                  // SearchOrders(controllerFilter: controllerFilter, action: () {}),
                  Expanded(
                    child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var raw = docs[index];
                        ItemStock item = ItemStock.fromData(raw);

                        return StockCard(
                          created_at: item.created_at,
                          title: item.title,
                          total: item.total,
                          unit: item.unit,
                          used: (item.consumed + item.losses),
                          onTap: () async {
                            await context
                                .read<StockCubit>()
                                .selectStockItem(item)
                                .then((value) => Navigator.pushNamed(
                                    context, AppRoutes.stockDetails));
                          },
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
