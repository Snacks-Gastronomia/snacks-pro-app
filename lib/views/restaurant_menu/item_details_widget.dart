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
import 'package:snacks_pro_app/views/restaurant_menu/widgets/new_option_item.dart';

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
                  Text(
                    'Tempo de preparo(minutos)',
                    style: AppTextStyles.medium(18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: const [7, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: context.read<MenuCubit>().changeTime,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "Ex.: 30",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   'Valor',
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
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: [
                  //       FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  //     ],
                  //     textInputAction: TextInputAction.next,
                  //     onChanged: context.read<MenuCubit>().changePrice,
                  //     decoration: InputDecoration(
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 15, vertical: 16),
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //         borderRadius: BorderRadius.circular(0),
                  //       ),
                  //       hintText: "Ex.: 2,00",
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Text(
                    'Categoria',
                    style: AppTextStyles.medium(18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DottedBorder(
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: [7, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: BlocBuilder<MenuCubit, MenuState>(
                        builder: (context, snapshot) {
                      return DropdownButton<String>(
                        value: snapshot.item.category,
                        hint: Text(
                          "Selecione",
                          style:
                              AppTextStyles.regular(16, color: Colors.black26),
                        ),
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: AppTextStyles.medium(16, color: Colors.black54),
                        isExpanded: true,
                        itemHeight: 55,
                        underline: Container(
                          height: 2,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? value) =>
                            context.read<MenuCubit>().changeCategory(value),
                        borderRadius: BorderRadius.circular(15),
                        items: ["Bebidas", "Comida Japonesa", "Outros"]
                            .map((String value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                      );
                    }),
                  ),
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
                  //     keyboardType: TextInputType.number,
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
                  // ElevatedButton(
                  //   onPressed: () {
                  //     var item = context.read<MenuCubit>().state.item;
                  //     if (item.category != null &&
                  //         item.value != 0 &&
                  //         item.time != 0) {
                  //       buttonAction();
                  //     }
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15)),
                  //       backgroundColor: Colors.black,
                  //       fixedSize: const Size(double.maxFinite, 59)),
                  //   child: Text(
                  //     'Salvar',
                  //     style: AppTextStyles.regular(16, color: Colors.white),
                  //   ),
                  // ),
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
