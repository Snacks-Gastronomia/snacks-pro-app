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
  const AddStock({super.key, this.increment, this.losses});
  final bool? increment;
  final bool? losses;

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
                ItemStock newItem = itemStock.copyWith(
                  title: controllerTitle.text,
                  dateTime: DateFormat('dd/MM/yyyy').parse(controllerDate.text),
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
