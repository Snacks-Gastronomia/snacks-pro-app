import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/services/items_service.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_consume.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_number_field_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_text_field_stock.dart';

class AddItemModal extends StatelessWidget {
  const AddItemModal({super.key, required this.itemStock});
  final ItemStock itemStock;

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerTitle = TextEditingController();
    TextEditingController controllerConsume = TextEditingController();
    final service = NewStockService();

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(children: [
        Text(
          "Novo Item",
          style: AppTextStyles.bold(22),
        ),
        const SizedBox(
          height: 20,
        ),
        DropDownItemsMenu(
          controller: controllerTitle,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomNumberFieldStock(
            title: 'Consumo',
            hint: 'Valor gasto',
            controller: controllerConsume),
        const SizedBox(
          height: 50,
        ),
        CustomSubmitButton(
            onPressedAction: () {
              var consume = controllerConsume.text;
              var title = controllerTitle.text;

              if (title.isNotEmpty &&
                  title != "Selecione um item" &&
                  consume.isNotEmpty) {
                var itemConsume =
                    ItemConsume(title: title, consume: int.parse(consume));
                service.addItem(itemConsume: itemConsume, itemStock: itemStock);
                Navigator.pop(context);
              }
            },
            label: 'Adicionar')
      ]),
    );
  }
}

class DropDownItemsMenu extends StatefulWidget {
  const DropDownItemsMenu({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<DropDownItemsMenu> createState() => _DropDownItemsMenuState();
}

class _DropDownItemsMenuState extends State<DropDownItemsMenu> {
  String selected = 'Selecione um item';
  final service = NewStockService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: service.getItemsMenu(),
        builder: (context, stream) {
          if (stream.hasData) {
            var docs = stream.data!.docs;
            List list = docs.map((e) => Item.fromMap(e.data()).title).toList();
            list.sort();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Medida",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF7F8F9),
                    border:
                        Border.all(color: const Color(0xffE8ECF4), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    focusColor: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: const Color(0xffF7F8F9),
                    value: selected,
                    underline: Container(),
                    items: <String>['Selecione um item', ...list]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selected = newValue!;
                        widget.controller.text = newValue;
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
