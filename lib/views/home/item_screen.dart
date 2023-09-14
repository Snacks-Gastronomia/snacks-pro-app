import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/item_screen/item_screen_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/modal_content_obs.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({Key? key, required this.order, required this.permission})
      : super(key: key);

  OrderModel order;
  AppPermission permission;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ItemScreenCubit>().insertItem(widget.order, true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 45,
              child: BlocBuilder<ItemScreenCubit, ItemScreenState>(
                builder: (context, state) {
                  return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var option = widget.order.item.options[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${option["title"]}',
                                style: AppTextStyles.medium(16,
                                    color: Colors.black),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: "pt", symbol: r"R$ ")
                                    .format(double.parse(
                                        option["value"].toString())),
                                style: AppTextStyles.medium(12,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 10,
                          ),
                      itemCount: widget.order.item.options.length);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      context.read<MenuCubit>().updateItem(widget.order.item);
                      Navigator.pushNamed(context, AppRoutes.newItem);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      'Atualizar',
                      style: AppTextStyles.regular(16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      context.read<HomeCubit>().removeItem(
                          widget.order.item.id ?? "",
                          widget.order.item.image_url ?? "");
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      // minimumSize: Size(width, height),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: const Color(0xffE20808),
                    ),
                    child: Text(
                      'Remover',
                      style: AppTextStyles.regular(16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(55),
                      bottomRight: Radius.circular(55)),
                  child: widget.order.item.image_url == null ||
                          widget.order.item.image_url!.isEmpty ||
                          !widget.order.item.image_url!.contains("https")
                      ? Container(
                          color: Colors.grey.shade200,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.snacks,
                              color: Colors.grey.shade400,
                              // fit: BoxFit,
                              width: 150,
                            ),
                          ),
                        )
                      : Image.network(
                          widget.order.item.image_url!,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * 0.5,

                          // height: 200,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color(0xffF6F6F6),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(41, 41)),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                            size: 19,
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Detalhes',
                        style: AppTextStyles.textShadow(
                            AppTextStyles.medium(20, color: Colors.white),
                            shadows: [
                              const BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 20,
                                spreadRadius: 10,
                                color: Colors.black,
                              ),
                            ]),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            context
                                .read<MenuCubit>()
                                .updateItem(widget.order.item);
                            Navigator.pushNamed(context, AppRoutes.updateImage);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.order.item.title,
                        style: AppTextStyles.medium(18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.order.item.time} min',
                            style: AppTextStyles.medium(16),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Este prato serve ${widget.order.item.num_served} pessoa${widget.order.item.num_served > 1 ? "s" : ""}',
                    style: AppTextStyles.regular(12),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    widget.order.item.description!,
                    style: AppTextStyles.regular(15,
                        color: const Color(0xff979797)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.order.item.extras.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Extras",
                          style: AppTextStyles.semiBold(18),
                        ),
                        if (widget.order.item.limit_extra_options != null)
                          Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Selecione até ${widget.order.item.limit_extra_options} opções',
                                style: AppTextStyles.light(12),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                            itemCount: widget.order.item.extras.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var list = List.from(widget.order.item.extras);
                              double value =
                                  double.parse(list[index]['value'].toString());

                              return BlocBuilder<ItemScreenCubit,
                                      ItemScreenState>(
                                  // stream: null,
                                  builder: (context, state) {
                                bool selected =
                                    state.order!.extras.contains(list[index]);
                                return Container(
                                  // height: 50,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: selected
                                          ? Colors.black
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: const Border.fromBorderSide(
                                          BorderSide(width: 2))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.plus_one_rounded,
                                            color: selected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              list[index]["title"],
                                              style: AppTextStyles.medium(
                                                16,
                                                color: selected
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "+${NumberFormat.currency(locale: "pt", symbol: r"R$ ").format(value)}",
                                        style: AppTextStyles.medium(16,
                                            color: AppColors.highlight),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            })
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
