import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_item_modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/blue_buttom_add.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/common_button_stock.dart';

class ItensStock extends StatelessWidget {
  const ItensStock({super.key, required this.item});
  final ItemStock item;
  @override
  Widget build(BuildContext context) {
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
            trailing: Text("Total: ${item.amount}"),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 350,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: item.items?.length ?? 0,
              itemBuilder: (context, index) {
                var itemMenu = item.items?[index];
                return ListTile(
                  title: Text(itemMenu?.title ?? ''),
                  trailing: Text("${itemMenu?.consume}${item.measure}"),
                );
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          BlueButtomAdd(
            action: () => modal.showModalBottomSheet(
                context: context, content: const AddItemModal()),
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
