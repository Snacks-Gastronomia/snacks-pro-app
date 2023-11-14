import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
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
    return Padding(
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
            const CustomTextFieldStock(title: 'Título'),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: const [
              Flexible(
                flex: 2,
                child: CustomNumberFieldStock(title: 'Quantidade'),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 1,
                child: DropdownStock(),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (losses != true)
            const CustomNumberFieldStock(
                title: 'Número do documento (opcional)'),
          const SizedBox(
            height: 20,
          ),
          const CustomDataFieldStock(title: 'Data de entrada'),
          const SizedBox(
            height: 20,
          ),
          if (losses != true) const CustomNumberFieldStock(title: 'Valor'),
          const SizedBox(
            height: 20,
          ),
          const CustomTextFieldStock(
            title: 'Descrição',
            isDescription: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                fixedSize: const Size(double.maxFinite, 59)),
            child: const Text('Adicionar'),
          ),
          TextButton(
              onPressed: () {},
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }
}
