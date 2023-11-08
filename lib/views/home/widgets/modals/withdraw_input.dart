import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class WithdrawInput extends StatefulWidget {
  const WithdrawInput({super.key});

  @override
  _WithdrawInputState createState() => _WithdrawInputState();
}

class _WithdrawInputState extends State<WithdrawInput> {
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Retirada',
            style: AppTextStyles.bold(22),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Valor correspondente ao total retirado',
            style: AppTextStyles.regular(16),
          ),
          const SizedBox(
            height: 25,
          ),
          TextField(
            controller: _valueController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: AppTextStyles.bold(50),
            inputFormatters: [CurrencyInputFormatter()],
            decoration:
                const InputDecoration.collapsed(hintText: 'R\$ 2.000,00'),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomSubmitButton(
            onPressedAction: () {
              String cleanedText =
                  _valueController.text.replaceAll(RegExp(r'[^0-9]'), '');
              int intValue =
                  int.parse(cleanedText.isNotEmpty ? cleanedText : "0");

              intValue > 0 ? Navigator.pop(context, intValue / 100) : null;
            },
            label: 'Nova Retirada',
          ),
        ],
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String cleanedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    double value = double.parse(cleanedText) / 100;

    final formatter = NumberFormat.simpleCurrency(locale: "pt_BR");
    String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
