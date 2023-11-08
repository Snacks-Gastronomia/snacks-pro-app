import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/custom_text_field_stock.dart';

class AddStock extends StatelessWidget {
  const AddStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            "Adicionar ao estoque",
            style: AppTextStyles.bold(22),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFieldStock(title: 'Título'),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                child: CustomTextFieldStock(title: 'Quantidade'),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: CustomTextFieldStock(title: 'Medida'),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFieldStock(title: 'Valor'),
          const SizedBox(
            height: 20,
          ),
          CustomTextFieldStock(
            title: 'Descrição',
            isDescription: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Adicionar  '),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                fixedSize: const Size(double.maxFinite, 59)),
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
    );
  }
}
