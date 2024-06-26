import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class LimitOptionsModal extends StatelessWidget {
  const LimitOptionsModal({
    Key? key,
    required this.submit,
  }) : super(key: key);

  final VoidCallback submit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<MenuCubit>(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Limite de opções',
              style: AppTextStyles.semiBold(25),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    return Text(
                      (state.item.limit_extra_options ?? 0).toString(),
                      style: AppTextStyles.semiBold(80, color: Colors.black),
                    );
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          int value = context
                              .read<MenuCubit>()
                              .state
                              .item
                              .options
                              .length;
                          int newValue = value++;

                          if (newValue < value) {
                            context
                                .read<MenuCubit>()
                                .changeLimitOptions(newValue);
                          }
                        },
                        icon: const Icon(Icons.keyboard_arrow_up_rounded)),
                    IconButton(
                        onPressed: () {
                          int value = context
                              .read<MenuCubit>()
                              .state
                              .item
                              .options
                              .length;
                          int newValue = --value;

                          if (newValue > 0) {
                            context
                                .read<MenuCubit>()
                                .changeLimitOptions(newValue);
                          }
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded)),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomSubmitButton(
                onPressedAction: () {
                  Navigator.pop(context);
                  submit();
                },
                label: "Continuar"),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancelar",
                style: AppTextStyles.medium(14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
