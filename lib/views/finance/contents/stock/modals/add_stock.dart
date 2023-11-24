import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_data_field_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_number_field_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_text_field_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/dropdown_stock.dart';

class AddStock extends StatelessWidget {
  const AddStock({super.key, this.increment, this.losses, this.item});
  final bool? increment;
  final bool? losses;
  final ItemStock? item;

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerTitle = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    TextEditingController controllerDoc = TextEditingController();
    TextEditingController controllerDate = TextEditingController();
    TextEditingController controllerValue = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();
    TextEditingController controllerMeasure = TextEditingController();

    NewStockService stockService = NewStockService();
    ItemStock itemStock = ItemStock.initial();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            if (increment != true)
              Text(
                losses != true ? "Adicionar ao estoque" : "Nova perda",
                style: AppTextStyles.bold(22),
              ),
            if (increment == true)
              Text(
                "Incrementar estoque",
                style: AppTextStyles.bold(22),
              ),
            const SizedBox(
              height: 20,
            ),
            if (losses != true && increment != true)
              CustomTextFieldStock(
                hint: 'Carne bovina',
                title: 'Título',
                controller: controllerTitle,
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: CustomNumberFieldStock(
                    title: 'Quantidade',
                    hint: '100',
                    controller: controllerAmount,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  child: DropdownStock(
                    controller: controllerMeasure,
                    initial: losses == true ? item!.measure : null,
                    disable: losses ?? increment,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (losses != true)
              CustomNumberFieldStock(
                title: 'Número do documento (opcional)',
                hint: '0101110',
                controller: controllerDoc,
              ),
            const SizedBox(
              height: 20,
            ),
            CustomDataFieldStock(
              title: 'Data de entrada',
              controller: controllerDate,
            ),
            const SizedBox(
              height: 20,
            ),
            if (losses != true)
              CustomNumberFieldStock(
                title: 'Valor',
                hint: '100',
                controller: controllerValue,
              ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFieldStock(
              title: 'Descrição',
              isDescription: true,
              controller: controllerDescription,
              hint: "Escreva aqui",
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                String dateTIme = controllerDate.text.replaceAll('/', '-');
                if (losses == true) {
                  stockService.addLossesItemStock(
                      item: item!,
                      losses: int.parse(controllerAmount.text),
                      dateTime: dateTIme,
                      description: controllerDescription.text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else if (increment == true) {
                  stockService.updateItemStock(
                      item: item!,
                      amount: int.parse(controllerAmount.text),
                      value: int.parse(controllerValue.text),
                      dateTime:
                          DateFormat('dd/MM/yyy').parse(controllerDate.text));
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  ItemStock newItem = itemStock.copyWith(
                    title: controllerTitle.text,
                    dateTime:
                        DateFormat('dd/MM/yyyy').parse(controllerDate.text),
                    description: controllerDescription.text,
                    document: int.tryParse(controllerAmount.text),
                    amount: double.tryParse(
                        controllerAmount.text.replaceAll(',', '.')),
                    measure: controllerMeasure.text,
                    value: double.tryParse(
                        controllerValue.text.replaceAll(',', '.')),
                  );
                  bool validate = stockService.validateItem(newItem);
                  stockService.printItemStock(newItem);
                  validate ? stockService.addItemToStock(newItem) : null;
                  validate ? Navigator.pop(context) : null;
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fixedSize: const Size(double.maxFinite, 59)),
              child: const Text('Adicionar'),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
      ),
    );
  }
}
