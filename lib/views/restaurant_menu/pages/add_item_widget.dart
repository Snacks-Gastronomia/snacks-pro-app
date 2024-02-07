import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class AddItemWidget extends StatelessWidget {
  const AddItemWidget({
    Key? key,
    required this.buttonAction,
    required this.backAction,
  }) : super(key: key);
  final VoidCallback buttonAction;
  final VoidCallback backAction;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 125,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adicone um titulo',
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
                      maxLines: 1,
                      maxLength: 30,
                      onChanged: context.read<MenuCubit>().changeTitle,
                      textInputAction: TextInputAction.next,
                      controller: context.read<MenuCubit>().state.status ==
                              AppStatus.editing
                          ? TextEditingController(
                              text: context.read<MenuCubit>().state.item.title)
                          : null,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "Ex.: X-burguer",
                      ),
                      style: AppTextStyles.regular(18, color: Colors.black87),
                    )),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<MenuCubit, MenuState>(builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${30 - snapshot.item.title.length} caracteres restantes',
                        textAlign: TextAlign.end,
                        style: AppTextStyles.regular(14,
                            color: const Color(0xff979797)),
                      ),
                    ],
                  );
                }),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Adicone uma descrição',
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
                      maxLines: 6,
                      maxLength: 200,
                      onChanged: context.read<MenuCubit>().changeDescription,
                      textInputAction: TextInputAction.done,
                      controller: context.read<MenuCubit>().state.status ==
                              AppStatus.editing
                          ? TextEditingController(
                              text: context
                                  .read<MenuCubit>()
                                  .state
                                  .item
                                  .description)
                          : null,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "Descrição",
                      ),
                      style: AppTextStyles.regular(18, color: Colors.black87),
                    )),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<MenuCubit, MenuState>(builder: (context, snapshot) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${200 - snapshot.item.description!.length} caracteres restantes',
                        textAlign: TextAlign.end,
                        style: AppTextStyles.regular(14,
                            color: const Color(0xff979797)),
                      ),
                    ],
                  );
                }),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    var cubit = context.read<MenuCubit>().state;
                    if (cubit.item.title.isNotEmpty) buttonAction();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.black,
                      fixedSize: const Size(double.maxFinite, 59)),
                  child: Text(
                    'Continuar',
                    style: AppTextStyles.regular(16, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: backAction,
                  child: Text(
                    'Voltar',
                    style: AppTextStyles.regular(16,
                        color: const Color(0xff35C2C1)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
