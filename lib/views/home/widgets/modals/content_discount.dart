import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class ContentDiscount extends StatelessWidget {
  const ContentDiscount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: BlocBuilder<MenuCubit, MenuState>(
        bloc: context.read<MenuCubit>(),
        builder: (context, state) {
          final cubit = context.read<MenuCubit>();
          return Column(
            children: [
              Text(
                "De quanto será o desconto?",
                style: AppTextStyles.semiBold(24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "${state.item.discount!.toInt()}%",
                    style: AppTextStyles.bold(80),
                  ),
                  IconButton(
                    onPressed: () => cubit.incrementDiscount(),
                    icon: const Icon(Icons.add, color: Colors.blue),
                  )
                ],
              ),
              CustomSubmitButton(
                label: "Adicionar desconto",
                onPressedAction: () {},
                loading: false,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
