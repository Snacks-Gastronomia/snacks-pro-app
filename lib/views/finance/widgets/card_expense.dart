import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';

class CardExpense extends StatelessWidget {
  const CardExpense({
    Key? key,
    required this.title,
    this.month,
    required this.value,
    this.iconColorBlack = false,
    this.icon = Icons.pie_chart_outline_rounded,
    this.enableDelete = true,
    this.deleteAction,
  }) : super(key: key);
  final String title;
  final String? month;
  final double value;
  final bool iconColorBlack;
  final IconData? icon;
  final bool enableDelete;
  final VoidCallback? deleteAction;
  @override
  Widget build(BuildContext context) {
    return Slidable(
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
          value: value,
          iconColorBlack: iconColorBlack,
          icon: icon,
          month: month,
        ));
  }
}

class CardExpenseContent extends StatelessWidget {
  const CardExpenseContent({
    Key? key,
    required this.title,
    this.month,
    required this.value,
    required this.iconColorBlack,
    this.icon,
  }) : super(key: key);
  final String title;
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
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.medium(16),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value),
          style: AppTextStyles.medium(18, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}
