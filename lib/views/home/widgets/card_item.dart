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
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/item_screen/item_screen_cubit.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';

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
    double value = double.parse(item.options[0]["value"].toString());
    print(item.id);
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
                  child: item.image_url == null ||
                          item.image_url!.isEmpty ||
                          item.image_url!.contains("https")
                      ? Center(
                          child: SvgPicture.asset(
                            AppImages.snacks,
                            color: Colors.grey.shade400,
                            // fit: BoxFit.,
                            width: 70,
                          ),
                        )
                      :
                      // FadeInImage(
                      //     image: NetworkImage(item.image_url!),
                      //     placeholder: AssetImage(AppImages.snacks),
                      //     imageErrorBuilder: (context, error, stackTrace) {
                      //       return Image.asset(AppImages.snacks,
                      //           fit: BoxFit.fitWidth);
                      //     },
                      //     fit: BoxFit.fitWidth,
                      //   ),
                      Image.network(
                          item.image_url!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
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
                              .format(value),
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
        ],
      );
    });
  }
}
