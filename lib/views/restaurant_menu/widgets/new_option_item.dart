import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/restaurant_menu/state/menu/menu_cubit.dart';

class NewOptionItemModal extends StatelessWidget {
  NewOptionItemModal({super.key});

  final title = TextEditingController();
  final value = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<MenuCubit>(context),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Nova opção',
                style: AppTextStyles.semiBold(25),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                textInputAction: TextInputAction.next,
                controller: title,
                decoration: InputDecoration(
                  fillColor: const Color(0xffF7F8F9),
                  filled: true,
                  hintStyle: AppTextStyles.medium(16,
                      color: const Color(0xff8391A1).withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  hintText: 'Nome',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(signed: true),
                controller: value,
                decoration: InputDecoration(
                  fillColor: const Color(0xffF7F8F9),
                  filled: true,
                  hintStyle: AppTextStyles.medium(16,
                      color: const Color(0xff8391A1).withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                  hintText: 'Value',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomSubmitButton(
                  onPressedAction: () {
                    if (title.text.isNotEmpty && value.text.isNotEmpty) {
                      context
                          .read<MenuCubit>()
                          .addOptionToItem(title.text, value.text);
                      title.clear();
                      value.clear();
                      Navigator.pop(context);
                    }
                  },
                  label: "Feito"),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: AppTextStyles.medium(14, color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
