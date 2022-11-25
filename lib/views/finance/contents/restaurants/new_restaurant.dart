import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/employees/employees_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/finance/finance_home_cubit.dart';

class NewRestaurantScreen extends StatelessWidget {
  const NewRestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<FinanceCubit>(context),
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomSubmitButton(
                  label: "Adicionar restaurante",
                  onPressedAction: () =>
                      context.read<FinanceCubit>().saveRestaurant(context),
                )),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          context.read<FinanceCubit>().clearAUX();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(41, 41)),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                          size: 19,
                        )),
                    SvgPicture.asset(
                      "assets/icons/snacks_logo.svg",
                      height: 30,
                      color: Colors.black.withOpacity(0.1),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<FinanceCubit, FinanceHomeState>(
                        builder: (context, state) {
                      return Text(
                        state.status == AppStatus.editing
                            ? "Editar ${state.restaurantAUX!.rname}"
                            : 'Novo restaurante',
                        style: AppTextStyles.semiBold(30),
                      );
                    }),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextField(
                        label: "Nome do restaurante",
                        controller: TextEditingController(
                            text: context
                                    .read<FinanceCubit>()
                                    .state
                                    .restaurantAUX
                                    ?.rname ??
                                ""),
                        onChange:
                            context.read<FinanceCubit>().changeRestaurantName),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        label: "Categoria",
                        controller: TextEditingController(
                            text: context
                                    .read<FinanceCubit>()
                                    .state
                                    .restaurantAUX
                                    ?.rcategory ??
                                ""),
                        onChange: context
                            .read<FinanceCubit>()
                            .changeRestaurantCategory),
                    if (context.read<FinanceCubit>().state.status !=
                        AppStatus.editing)
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              label: "Nome do proprietário",
                              onChange: context
                                  .read<FinanceCubit>()
                                  .changeRestaurantOwnerName),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              label: "Telefone",
                              inputType: TextInputType.number,
                              onChange: context
                                  .read<FinanceCubit>()
                                  .changeRestaurantOwnerPhone),
                        ],
                      )
                  ],
                ),
              );
            }),
          ),
        ));
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    required this.onChange,
    this.inputType,
    this.controller,
  }) : super(key: key);
  final String label;
  final Function(String)? onChange;
  final TextInputType? inputType;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
      onChanged: onChange,
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: inputType ?? TextInputType.text,
      inputFormatters: [
        if (inputType == TextInputType.number)
          MaskTextInputFormatter(
              mask: '(##) #####-####',
              filter: {"#": RegExp(r'[0-9]')},
              type: MaskAutoCompletionType.lazy)
      ],
      decoration: InputDecoration(
        fillColor: const Color(0xffF7F8F9),
        filled: true,
        hintStyle: AppTextStyles.medium(16,
            color: const Color(0xff8391A1).withOpacity(0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xffE8ECF4), width: 1)),
        hintText: label,
      ),
    );
  }
}
