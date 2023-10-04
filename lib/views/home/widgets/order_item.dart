import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/models/order_response.dart';

import '../../../core/app.text.dart';

import 'custom_switch.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    Key? key,
    required this.order,
    required this.amount,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);
  final ItemDetails order;
  final int amount;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    // double extrasValue = order.extras!.isNotEmpty
    //     ? order.extras!
    //         .map((e) => double.parse(e["value"].toString()))
    //         .reduce((value, element) => value + element)
    //     : 0;
    return Stack(
      children: [
        Container(
          // height: 70,
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 5),
          // margin: EdgeInsets.symmetric(horizontal: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          order.title,
                          style: AppTextStyles.regular(16),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                            .format((double.parse(order.value.toString()))
                                // +
                                //     extrasValue
                                ),
                        style: AppTextStyles.regular(14,
                            color: const Color(0xff000000)),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSwitch(
                      decrementAction: onDecrement,
                      incrementAction: onIncrement,
                      value: amount),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      onPressed: onDelete,
                      child: Text(
                        "Remover",
                        style:
                            AppTextStyles.light(12, color: Colors.red.shade600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
