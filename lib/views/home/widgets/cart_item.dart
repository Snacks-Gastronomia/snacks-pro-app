import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/app.images.dart';
import '../../../core/app.text.dart';
import '../../../models/order_model.dart';
import 'custom_switch.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.order,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);
  final OrderModel order;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    double extras_value = order.extras.isNotEmpty
        ? order.extras
            .map((e) => double.parse(e["value"].toString()))
            .reduce((value, element) => value + element)
        : 0;
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
                  // const SizedBox(
                  //   width: 7,
                  // ),
                  Container(
                    height: 60,
                    width: 60,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Stack(
                      children: [
                        order.item.image_url == null ||
                                order.item.image_url!.isEmpty
                            ? Center(
                                child: SvgPicture.asset(
                                  AppImages.snacks,
                                  color: Colors.grey.shade400,
                                  // fit: BoxFit.,
                                  width: 70,
                                ),
                              )
                            : Image.network(
                                order.item.image_url!,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                    AppImages.snacks,
                                    color: Colors.grey.shade400,
                                    // fit: BoxFit.,
                                    width: 70,
                                  );
                                },
                              ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 60,
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                "${order.item.time} min",
                                style: AppTextStyles.medium(10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                          "${order.item.title} - ${order.option_selected["title"]}",
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
                            .format((double.parse(order.option_selected["value"]
                                        .toString()) *
                                    order.amount) +
                                extras_value),
                        style:
                            AppTextStyles.regular(14, color: Color(0xff09B44D)),
                      ),
                      // SizedBox(
                      //   width: 150,
                      //   child: Text(
                      //     order.observations,
                      //     softWrap: true,
                      //     // maxLines: 3,
                      //     style: AppTextStyles.regular(12,
                      //         color: const Color(0xff979797)),
                      //   ),
                      // ),
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
                      value: order.amount),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      onPressed: onDelete,
                      // style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
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
        // Positioned(
        //   left: 0,
        //   top: 3,
        //   child: Container(
        //     height: 25,
        //     width: 25,
        //     decoration: const BoxDecoration(
        //         color: Colors.white, shape: BoxShape.circle),
        //     child: Center(
        //         child: Text(
        //       order.amount.toString(),
        //       style: AppTextStyles.regular(14),
        //     )),
        //   ),
        // ),
      ],
    );
  }
}
