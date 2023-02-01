import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/item_screen/item_screen_cubit.dart';

class CardItemWidget extends StatelessWidget {
  CardItemWidget({
    Key? key,
    required this.item,
    required this.permission,
  }) : super(key: key);
  final Item item;
  final modal = AppModal();
  final AppPermission permission;
  @override
  Widget build(BuildContext context) {
    var order = OrderModel(item: item, observations: "", option_selected: {});

    return Builder(builder: (context) {
      return Stack(
        children: [
          // Container(
          //     width: 155,
          //     height: 155,
          //     clipBehavior: Clip.hardEdge,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20),
          //         color: Colors.amber)),
          Container(
            width: 155,
            height: 155,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffF6F6F6),
            ),

            // color: Colors.amber),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: item.image_url == null || item.image_url!.isEmpty
                      ? Center(
                          child: SvgPicture.asset(
                            AppImages.snacks,
                            color: Colors.grey.shade400,
                            // fit: BoxFit.,
                            width: 70,
                          ),
                        )
                      : Image.network(item.image_url!, fit: BoxFit.cover),
                ),
                Container(
                  height: 2,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.title,
                            // maxLines: 2,
                            style: AppTextStyles.medium(14,
                                color: AppColors.highlight),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true),
                        Text(
                          NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                              .format(item.value),
                          style: AppTextStyles.regular(15,
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (!item.active)
            Container(
                width: 155,
                height: 155,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white54)),
          if (permission == AppPermission.radm ||
              permission == AppPermission.employee)
            Positioned(
              top: -10,
              right: 0,
              child: SizedBox(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () => context
                          .read<HomeCubit>()
                          .disableItem(item.id!, !item.active),
                      tooltip:
                          item.active ? "Item disponível" : "Item indisponível",
                      icon: Container(
                          // height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.do_not_disturb,
                            color: item.active
                                ? const Color(0xffFE555D).withOpacity(0.3)
                                : const Color(0xffFE555D),
                          )),
                      color: Colors.black87,
                      iconSize: 30,
                    );
                  },
                ),
              ),
            )
          else
            Positioned(
              top: -10,
              right: 0,
              child: SizedBox(
                // height: 50,
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    // bool itemAdded = state.cart.contains(order);
                    return IconButton(
                      onPressed: () {
                        context.read<ItemScreenCubit>().insertItem(order, true);
                        context.read<CartCubit>().hasItem(order.item.id!)
                            ? context.read<CartCubit>().removeToCart(order)
                            : context.read<CartCubit>().addToCart(order);
                        //  modal.showModalBottomSheet(
                        //     context: context,
                        //     // isScrollControlled: true,
                        //     content: ModalContentObservation(
                        //         action: () {
                        //           BlocProvider.of<CartCubit>(context)
                        //               .addToCart(order);
                        //           Navigator.popUntil(context,
                        //               ModalRoute.withName(AppRoutes.home));
                        //         },
                        //         value: context
                        //             .read<ItemScreenCubit>()
                        //             .state
                        //             .order!
                        //             .observations,
                        //         onChanged: context
                        //             .read<ItemScreenCubit>()
                        //             .observationChanged));
                      },
                      tooltip: context.read<CartCubit>().hasItem(order.item.id!)
                          ? "Remover pedido"
                          : "Adicionar ao pedido",
                      icon: Container(
                          // height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child:
                              context.read<CartCubit>().hasItem(order.item.id!)
                                  ? Icon(
                                      Icons.remove_rounded,
                                      color: Colors.red.shade700,
                                    )
                                  : const Icon(Icons.add)),
                      color: Colors.black87,
                      iconSize: 30,
                    );
                  },
                ),
              ),
            )
        ],
      );
    });
  }
}
