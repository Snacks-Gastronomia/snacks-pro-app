import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/restaurant_menu/extras_widget.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/input_dashed_border.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/new_option_item.dart';
import 'package:snacks_pro_app/views/restaurant_menu/widgets/select_dashed_border.dart';

class ItemDetailsWidget extends StatelessWidget {
  const ItemDetailsWidget({
    Key? key,
    required this.buttonAction,
    required this.backAction,
  }) : super(key: key);
  final VoidCallback backAction;
  final VoidCallback buttonAction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MenuCubit>(context),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 140,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashedBorderInput(
                    label: 'Tempo de preparo(minutos)',
                    onChange: context.read<MenuCubit>().changeTime,
                    status: context.read<MenuCubit>().state.status,
                    initialValue: context.read<MenuCubit>().state.item.time.toString(),
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DashedBorderInput(
                    label: 'Serve quantas pessoas?',
                    onChange: context.read<MenuCubit>().changeNumServed,
                    status: context.read<MenuCubit>().state.status,
                    initialValue: context
                        .read<MenuCubit>()
                        .state
                        .item
                        .num_served
                        .toString(),
                    keyboardType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<MenuCubit, MenuState>(
                    builder: (context, state) {
                      return DashedBorderSelect(
                          label: 'Categoria',
                          items: const [
                            "Bebidas",
                            "Drinks",
                            "Grill",
                            "Hambúguer",
                            "Pizza",
                            "Comida Japonesa",
                            "Petiscos",
                            "Sobremesa",
                            "Vinhos"
                          ],
                          value: state.item.category,
                          onChange: context.read<MenuCubit>().changeCategory,
                          status: state.status);
                    },
                  ),
                  // Text(
                  //   'Categoria',
                  //   style: AppTextStyles.medium(18),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  // DottedBorder(
                  //   color: Colors.grey,
                  //   strokeWidth: 1.5,
                  //   dashPattern: [7, 4],
                  //   borderType: BorderType.RRect,
                  //   radius: const Radius.circular(12),
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: BlocBuilder<MenuCubit, MenuState>(
                  //       builder: (context, snapshot) {
                  //     return DropdownButton<String>(
                  //       value: snapshot.item.category,
                  //       hint: Text(
                  //         "Selecione",
                  //         style:
                  //             AppTextStyles.regular(16, color: Colors.black26),
                  //       ),
                  //       icon: const Icon(Icons.arrow_downward),
                  //       elevation: 16,
                  //       style: AppTextStyles.medium(16, color: Colors.black54),
                  //       isExpanded: true,
                  //       itemHeight: 55,
                  //       underline: Container(
                  //         height: 2,
                  //         color: Colors.transparent,
                  //       ),
                  //       onChanged: (String? value) =>
                  //           context.read<MenuCubit>().changeCategory(value),
                  //       borderRadius: BorderRadius.circular(15),
                  //       items: [
                  //         "Bebidas",
                  //         "Drinks",
                  //         "Grill",
                  //         "Hambúguer",
                  //         "Pizza",
                  //         "Comida Japonesa",
                  //         "Petiscos",
                  //         "Sobremes",
                  //         "Vinhos"
                  //       ]
                  //           .map((String value) => DropdownMenuItem(
                  //                 value: value,
                  //                 child: Text(value),
                  //               ))
                  //           .toList(),
                  //     );
                  //   }),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   'Volume',
                  //   style: AppTextStyles.medium(18),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // DottedBorder(
                  //   color: Colors.grey,
                  //   strokeWidth: 1.5,
                  //   dashPattern: const [7, 4],
                  //   borderType: BorderType.RRect,
                  //   radius: const Radius.circular(12),
                  //   child: TextFormField(
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  //     ], //
                  //     onChanged: context.read<MenuCubit>().changeMeasure,
                  //     textInputAction: TextInputAction.done,
                  //     keyboardType: TextInputType.numberWithOptions(signed: true),
                  //     decoration: InputDecoration(
                  //         contentPadding: const EdgeInsets.symmetric(
                  //             horizontal: 15, vertical: 16),
                  //         border: OutlineInputBorder(
                  //           borderSide: BorderSide.none,
                  //           borderRadius: BorderRadius.circular(0),
                  //         ),
                  //         hintText: "Ex.: 200",
                  //         suffixText:
                  //             context.read<MenuCubit>().state.item.category ==
                  //                     "Bebidas"
                  //                 ? "ml"
                  //                 : "gramas"),
                  //   ),
                  // ),
                ],
              ),
              Column(
                children: [
                  BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
                    return CustomSubmitButton(
                      onPressedAction: () {
                        var item = context.read<MenuCubit>().state.item;
                        if (item.category != null && item.time != 0) {
                          buttonAction();
                        }
                      },
                      loading: state.status == AppStatus.loading,
                      label: "Continuar",
                      loading_label: "",
                    );
                  }),
                  TextButton(
                    onPressed: backAction,
                    child: Text(
                      'Voltar',
                      style: AppTextStyles.regular(16,
                          color: const Color(0xff35C2C1)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
