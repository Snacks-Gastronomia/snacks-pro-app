import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.colors.dart';

import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/cancel_order.dart';
import 'package:snacks_pro_app/views/home/widgets/order/controllers/details_order_controller.dart';

import './signal_animation.dart';

class OrderDetailsContent extends StatelessWidget {
  const OrderDetailsContent({
    Key? key,
    required this.orders,
  }) : super(key: key);

  final List<OrderResponse> orders;

  @override
  Widget build(BuildContext context) {
    final DetailsOrderController detailsOrderController =
        DetailsOrderController();

    var ord = orders[0];

    double sum =
        orders.map((e) => e.value).reduce((value, element) => value + element);
    var total = NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(sum);
    var subTotal = NumberFormat.currency(locale: "pt", symbol: r"R$ ")
        .format((sum - ord.deliveryValue));
    var delivery = NumberFormat.currency(locale: "pt", symbol: r"R$ ")
        .format(ord.deliveryValue);

    bool allowCancel = ord.status != OrderStatus.delivered.name ||
        ord.status != OrderStatus.canceled.name;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(TextSpan(
                  text: 'Detalhes ',
                  style: AppTextStyles.semiBold(26, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: '#${ord.part_code}',
                      style: AppTextStyles.semiBold(26, color: Colors.black26),
                    )
                  ])),
              SizedBox(
                width: 25,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded)),
              )
            ],
          ),
          for (int i = 0; i < OrderStatus.values.length; i++)
            ListOrderByStatus(orders: orders, status: OrderStatus.values[i]),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppTextStyles.semiBold(12),
              ),
              Text(
                subTotal,
                style: AppTextStyles.regular(12,
                    color: Colors.black.withOpacity(.5)),
              ),
            ],
          ),
          if (ord.isDelivery)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery',
                  style: AppTextStyles.semiBold(12),
                ),
                Text(
                  delivery,
                  style: AppTextStyles.regular(12,
                      color: Colors.black.withOpacity(.5)),
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.semiBold(12),
              ),
              Text(
                total,
                style: AppTextStyles.regular(12,
                    color: Colors.black.withOpacity(.5)),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          if (!(ord.confirmed ?? false))
            ElevatedButton(
              onPressed: () {
                detailsOrderController.showModalConfimateOrder(
                    context, ord.part_code);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlight,
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  fixedSize: const Size(double.maxFinite, 45)),
              child: const Text('Confirmar'),
            ),
          if (allowCancel)
            TextButton(
              onPressed: () async {
                bool res = await AppModal().showModalBottomSheet(
                  context: context,
                  content: CancelOrder(
                    part_code: ord.part_code,
                  ),
                );
                if (res) {
                  context.read<OrdersCubit>().cancelOrder(ord.id);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 59)),
              child: Text(
                'Cancelar pedido',
                style:
                    AppTextStyles.regular(16, color: const Color(0xffE20808)),
              ),
            ),
          // ElevatedButton(
          //   onPressed: () => Navigator.pop(context),
          //   style: ElevatedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(15)),
          //       backgroundColor: Colors.black,
          //       fixedSize: const Size(double.maxFinite, 59)),
          //   child: Text(
          //     'Fechar',
          //     style: AppTextStyles.regular(16, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ListOrderByStatus extends StatelessWidget {
  const ListOrderByStatus({
    Key? key,
    required this.orders,
    required this.status,
  }) : super(key: key);

  final List<OrderResponse> orders;
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    List<ItemResponse> items = [];
    orders.map((element) {
      if (element.status == status.name) {
        items.addAll(element.items);
      }
    }).toList();

    return items.isNotEmpty
        ? Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  status == OrderStatus.delivered
                      ? const Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: Colors.black,
                        )
                      : SizedBox(
                          height: 25,
                          width: 25,
                          child: SignalRippleWidget(
                            count: 2,
                            color: status.getColor,
                          )),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(status.displayEnum,
                      style: AppTextStyles.regular(14,
                          color: const Color(0xff979797))),
                ],
              ),
              ListView.separated(
                  padding: const EdgeInsets.only(top: 15),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];

                    return ItemWidget(
                        title: "${item.amount} ${item.item.title}",
                        option: item.optionSelected.title,
                        observations: item.observations,
                        extras: item.extras!.isNotEmpty
                            ? item.extras!.length > 1
                                ? item.extras!
                                    .map((e) => e["title"].toString())
                                    .join(", ")
                                : item.extras![0]["title"]
                            : "",
                        value: item.amount * item.optionSelected.value,
                        image: item.item.imageUrl,
                        restaurant: item.item.restaurantName);
                  }),
            ],
          )
        : const SizedBox();
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    Key? key,
    required this.title,
    required this.option,
    required this.extras,
    required this.value,
    required this.restaurant,
    required this.image,
    required this.observations,
  }) : super(key: key);

  final String title;
  final String option;
  final String? observations;
  final String? image;
  final String extras;
  final double value;
  final String restaurant;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xffF6F6F6),
                    ),
                    child: image == null || image!.isEmpty
                        ? Center(
                            child: SvgPicture.asset(
                              AppImages.snacks,
                              width: 42,
                            ),
                          )
                        : Image.network(
                            image!,
                            height: 42,
                            width: 42,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: SvgPicture.asset(
                                  AppImages.snacks,
                                  width: 42,
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title ${option != title ? "- ${option.trim()}" : ""} ${extras.isNotEmpty ? '+ ($extras)' : ''}',
                          style: AppTextStyles.light(12),
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          restaurant,
                          style: AppTextStyles.light(11,
                              color: Colors.black.withOpacity(0.5)),
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text(
              NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value),
              style: AppTextStyles.medium(12),
            )
          ],
        ),
        if (observations!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Observações: $observations',
              style:
                  AppTextStyles.light(11, color: Colors.black.withOpacity(0.5)),
              overflow: TextOverflow.visible,
            ),
          ),
      ],
    );
  }
}
