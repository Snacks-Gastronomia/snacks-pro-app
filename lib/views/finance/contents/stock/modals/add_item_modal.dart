import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_number_field_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_text_field_stock.dart';

class AddItemModal extends StatelessWidget {
  const AddItemModal({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerTitle = TextEditingController();
    TextEditingController controllerConsume = TextEditingController();
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
        CustomTextFieldStock(
            title: 'Item',
            controller: controllerTitle,
            hint: 'Escolha um item'),
        CustomNumberFieldStock(
            title: 'Consumo',
            hint: 'Valor gasto',
            controller: controllerConsume),
        const SizedBox(
          height: 20,
        ),
        CustomSubmitButton(
            onPressedAction: () => Navigator.pop(context), label: 'OK')
      ]),
    );
  }
}
