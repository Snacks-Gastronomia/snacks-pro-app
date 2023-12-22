// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class CardExpense extends StatelessWidget {
  const CardExpense({
    Key? key,
    required this.title,
    this.month,
    required this.value,
    this.iconColorBlack = false,
    this.enableDelete = true,
    this.icon,
    this.deleteAction,
    required this.subtitle,
    required this.docNumber,
    required this.supplier,
    required this.period,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final int docNumber;
  final String supplier;
  final String period;
  final double value;
  final String? month;
  final bool iconColorBlack;
  final IconData? icon;
  final bool enableDelete;
  final VoidCallback? deleteAction;
  @override
  Widget build(BuildContext context) {
    final modal = AppModal();
    return GestureDetector(
      onDoubleTap: () => modal.showModalBottomSheet(
          context: context,
          content: ModalExpense(
              title: title,
              subtitle: subtitle,
              docNumber: docNumber,
              supplier: supplier,
              period: period,
              value: value)),
      child: Slidable(
          key: const ValueKey(0),
          enabled: enableDelete,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.4,
            children: [
              CustomSlidableAction(
                onPressed: (context) {},
                autoClose: true,
                backgroundColor: Colors.transparent,
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // IconButton(
                    //     onPressed: null,
                    //     icon: Icon(
                    //       Icons.delete,
                    //       color: Color(0xffE20808),
                    //     ))

                    TextButton(
                      onPressed: deleteAction,
                      child: Text(
                        "Excluir",
                        style: AppTextStyles.light(14,
                            color: const Color(0xffE20808)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          child: CardExpenseContent(
            title: title,
            subtitle: subtitle,
            value: value,
            iconColorBlack: iconColorBlack,
            icon: icon ?? Icons.pie_chart_outline_rounded,
            month: month,
          )),
    );
  }
}

class CardExpenseContent extends StatelessWidget {
  const CardExpenseContent({
    Key? key,
    required this.title,
    this.subtitle,
    this.month,
    required this.value,
    required this.iconColorBlack,
    this.icon,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? month;
  final double value;
  final bool iconColorBlack;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color:
                      iconColorBlack ? Colors.black : const Color(0xffF0F6F5),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                icon,
                color: iconColorBlack ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 170,
              child: ListTile(
                title: Text(
                  title,
                  style: AppTextStyles.medium(16),
                ),
                subtitle: Text(subtitle ?? ''),
              ),
            ),
          ],
        ),
        Text(
          NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value),
          style: AppTextStyles.medium(18,
              color: value.isNegative ? Colors.red : Colors.green),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class ModalExpense extends StatelessWidget {
  const ModalExpense({
    super.key,
    required this.title,
    required this.subtitle,
    required this.docNumber,
    required this.supplier,
    required this.period,
    required this.value,
  });
  final String title;
  final String subtitle;
  final int docNumber;
  final String supplier;
  final String period;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detalhes",
            style: AppTextStyles.bold(22),
          ),
          const SizedBox(
            height: 25,
          ),
          ListTile(
            title: Text('Número do documento'),
            subtitle: Text("$docNumber"),
          ),
          ListTile(
            title: Text('Fornecedor'),
            subtitle: Text(supplier.isEmpty ? "Desconhecido" : supplier),
          ),
          ListTile(
            title: Text('Tipo de despesa'),
            subtitle: Text(title),
          ),
          ListTile(
            title: Text('Valor'),
            subtitle: Text("$value"),
          ),
          ListTile(
            title: Text('Periodo'),
            subtitle: Text(period),
          ),
          SizedBox(
            height: 25,
          ),
          CustomSubmitButton(
              onPressedAction: () => Navigator.pop(context), label: 'Fechar')
        ],
      ),
    );
  }
}
