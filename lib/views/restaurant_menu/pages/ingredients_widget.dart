import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/limit_options.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/new_extra.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/new_ingredient.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({
    Key? key,
    required this.backAction,
    required this.buttonAction,
  }) : super(key: key);
  final VoidCallback backAction;
  final VoidCallback buttonAction;

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  bool checkLimit = false;
  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MenuCubit>(context),
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar:
              BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
            return CustomSubmitButton(
              onPressedAction: () {
                widget.buttonAction();
              },
              label: state.status == AppStatus.editing
                  ? "Salvar alterações"
                  : "Salvar",
              loading: state.status == AppStatus.loading,
              loading_label: "Salvando...",
            );
          }),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredientes',
                  style: AppTextStyles.medium(18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.item.options.length,
                    itemBuilder: (context, index) {
                      var op = state.item.options[index];
                      var ing = op["ingredients"] ?? [];
                      print(ing);
                      return Column(
                        children: [
                          Text(op["title"]),
                          for (int i = 0; i < (ing as List).length; i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ing[i]["name"] +
                                          " - " +
                                          ing[i]["value"].toString() +
                                          ing[i]["unit"].toString(),
                                      style: AppTextStyles.medium(14),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () => context
                                        .read<MenuCubit>()
                                        .removeIngredient(
                                            ing[i]["name"], op["title"]),
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ))
                              ],
                            )
                        ],
                      );
                    },
                  );
                })),
                Center(
                  child: SizedBox(
                    height: 42,
                    child: DottedBorder(
                        color: const Color(0xff278EFF),
                        strokeWidth: 1.5,
                        dashPattern: const [7, 4],
                        borderType: BorderType.RRect,
                        padding: EdgeInsets.zero,
                        radius: const Radius.circular(10),
                        child: TextButton(
                            onPressed: () => modal.showModalBottomSheet(
                                withPadding: false,
                                context: context,
                                content: NewIngredientModal()),
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(250, 45)),
                            child: Text(
                              "Adicionar ingrediente",
                              style: AppTextStyles.medium(14,
                                  color: const Color(0xff278EFF)),
                            ))),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
