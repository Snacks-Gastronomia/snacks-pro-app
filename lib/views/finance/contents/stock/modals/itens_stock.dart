import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_item_modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_consume.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/blue_buttom_add.dart';

class ItensStock extends StatelessWidget {
  const ItensStock({super.key, required this.item});
  final ItemStock item;

  @override
  Widget build(BuildContext context) {
    final stock = NewStockService();
    final modal = AppModal();

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Itens',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "${item.items?.length ?? 0}",
              style: AppTextStyles.bold(22),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 350,
            child: StreamBuilder(
                stream: stock.getItemConsumeStream(item: item.title),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    var itemConsume = snapshot.data!;
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: itemConsume.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(itemConsume[index]['title']),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => stock.deleteItem(
                              itemConsume:
                                  ItemConsume.fromMap(itemConsume[index]),
                              stockItemId: item.title,
                              index: index),
                          background: Container(
                              padding: const EdgeInsets.only(right: 5),
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                          child: ListTile(
                            trailing: Text(
                              "${itemConsume[index]['consume']} ${item.measure}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            title: Text(itemConsume[index]['title']),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('Nenhum item encontrado.');
                  }
                }),
          ),
          const SizedBox(
            height: 25,
          ),
          BlueButtomAdd(
            action: () => modal.showModalBottomSheet(
                context: context,
                content: AddItemModal(
                  itemStock: item,
                )),
            label: 'Adicionar Item',
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
