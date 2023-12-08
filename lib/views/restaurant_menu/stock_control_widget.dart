import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/autcomplete.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class StockControlWidget extends StatelessWidget {
  StockControlWidget({
    Key? key,
    required this.buttonAction,
  }) : super(key: key);
  final VoidCallback buttonAction;
  final searchController = TextEditingController();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MenuCubit>(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredientes',
            style: AppTextStyles.medium(18),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomAutoComplete(
              searchController: searchController,
              onSelected: (value) {},

              // context
              //     .read<MenuCubit>()
              //     .addIngredient(value.title, value.unit),
              focus: focus,
              suggestionsCallback: (query) async => await context
                  .read<MenuCubit>()
                  .fetchIngredientsByQuery(query),
              itemBuilder: (context, option) => ListTile(
                    title: Text(
                      option.title,
                      style: AppTextStyles.medium(18),
                    ),
                  ),
              hintText: "Ex.: Limão"),
          // DottedBorder(
          //   color: Colors.grey,
          //   strokeWidth: 1.5,
          //   dashPattern: const [7, 4],
          //   borderType: BorderType.RRect,
          //   radius: const Radius.circular(12),
          //   child: TextFormField(
          //     textInputAction: TextInputAction.done,
          //     decoration: InputDecoration(
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          //       border: OutlineInputBorder(
          //         borderSide: BorderSide.none,
          //         borderRadius: BorderRadius.circular(0),
          //       ),
          //       suffixIcon: const Icon(Icons.search_rounded),
          //       hintText: "Ex.: Limão",
          //     ),
          //   ),
          // ),

          const SizedBox(
            height: 70,
          ),
          Center(
              child: BlocBuilder<MenuCubit, MenuState>(
                  key: UniqueKey(),
                  builder: (context, snapshot) {
                    if (snapshot.selected.isNotEmpty) {
                      final item = context.read<MenuCubit>().itemSelected();
                      final roundedValue = (item.volume).ceil().toInt();
                      return SleekCircularSlider(
                        // onChangeStart: (double value) {},
                        // onChangeEnd: (double value) {
                        //   print(value)
                        // },
                        // onChange: (value) => context
                        //     .read<MenuCubit>()
                        //     .changeIngredientVolume(value.ceil().toInt()),
                        innerWidget: (percentage) {
                          final roundedValue = percentage.ceil().toInt();
                          return Center(
                              child: Text(
                            '$roundedValue ${item.unit}',
                            style: AppTextStyles.medium(30, color: Colors.grey),
                          ));
                        },
                        appearance: const CircularSliderAppearance(
                          size: 200,
                        ),
                        min: 0,
                        max: 1000, //quantidade - item_volume;
                        initialValue: double.parse(roundedValue.toString()),
                      );
                    } else {
                      return const SizedBox();
                    }
                  })),
          Center(
            child: SizedBox(
              height: 100,
              child: BlocBuilder<MenuCubit, MenuState>(
                  key: UniqueKey(),
                  builder: (context, state) {
                    print(state.item.ingredients.length);
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 15,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.item.ingredients.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var item = state.item.ingredients[index];
                        return CardIngredient(
                            title: item,
                            volume: 0,
                            unit: item,
                            onTap: () => context
                                .read<MenuCubit>()
                                .changeSelectedItem(item),
                            onRemove: () {},
                            // context
                            //     .read<MenuCubit>()
                            //     .removeIngredient(item),
                            selected: state.selected == item);
                      },
                    );
                  }),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: buttonAction,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                primary: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Adicionar item',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CardIngredient extends StatelessWidget {
  const CardIngredient({
    Key? key,
    required this.title,
    required this.volume,
    required this.unit,
    required this.onTap,
    required this.onRemove,
    required this.selected,
  }) : super(key: key);

  final String title;
  final int volume;
  final String unit;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: const Border.fromBorderSide(
                    BorderSide(width: 2, color: Colors.grey))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.regular(16,
                      color: selected ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 3),
                Text(
                  '$volume $unit',
                  style: AppTextStyles.regular(12,
                      color: selected ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
        if (selected)
          SizedBox(
            height: 30,
            child: TextButton(
              onPressed: onRemove,
              child: Text(
                'Remover',
                style: AppTextStyles.regular(12, color: Colors.red[600]),
              ),
            ),
          )
      ],
    );
  }
}

class LineDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..strokeWidth = 2;
    var max = 35;
    var dashWidth = 5;
    var dashSpace = 5;
    double startY = 0;
    while (max >= 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
