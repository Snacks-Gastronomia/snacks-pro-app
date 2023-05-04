import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_model.dart';

class ConfirmOrderModal extends StatefulWidget {
  ConfirmOrderModal({
    Key? key,
    required this.value,
    required this.method,
  }) : super(key: key);
  final double value;
  final String method;

  @override
  State<ConfirmOrderModal> createState() => _ConfirmOrderModalState();
}

class _ConfirmOrderModalState extends State<ConfirmOrderModal> {
  final List<String> items = [
    "Cartão de crédito",
    "Cartão de débito",
    "Pix",
    "Dinheiro"
  ];
  String method = "";
  @override
  void initState() {
    // : implement initState
    method = widget.method;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Confirmação do pedido',
            style: AppTextStyles.semiBold(25),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Confirme os dados de pagamento do pedido!',
            style: AppTextStyles.light(16),
          ),
          ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              bool isSelected = items[index] == method;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    method = items[index];
                  });
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(
                          color: isSelected ? Colors.blue : Colors.black38,
                          width: 2)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        items[index],
                        style: AppTextStyles.regular(
                          16,
                          color: isSelected ? Colors.blue : Colors.black38,
                        ),
                      ),
                      isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.blue,
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Valor pago",
                  style: AppTextStyles.semiBold(16),
                ),
                Text(
                    NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                        .format(widget.value),
                    style: AppTextStyles.semiBold(16)),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomSubmitButton(
              onPressedAction: () {
                Navigator.pop(context, method);
              },
              label: "Confirmar"),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(
              "Cancelar",
              style: AppTextStyles.medium(16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
