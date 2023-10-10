import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_cubit.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_state.dart';

class AddCupom extends StatelessWidget {
  const AddCupom({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerCode = TextEditingController();
    TextEditingController controllerDiscount = TextEditingController();
    final cubit = context.read<CouponsCubit>();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: BlocBuilder<CouponsCubit, CouponsState>(
        builder: (context, state) {
          return Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      "Novo Cupom",
                      style: AppTextStyles.semiBold(22),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: controllerCode,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                          hintText: "Código do cupom",
                          filled: true,
                          fillColor: Colors.black12),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha esse campo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Stack(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2)
                          ],
                          controller: controllerDiscount,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none),
                              hintText: "Desconto",
                              filled: true,
                              fillColor: Colors.black12),
                          onChanged: (value) => cubit.setPercent(value),
                        ),
                        Container(
                          height: 58,
                          alignment: Alignment.centerRight,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(Icons.remove),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${state.percent}%",
                                  style: TextStyle(
                                      color: AppColors.highlight,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      cubit.increment();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    CustomSubmitButton(
                        onPressedAction: () {
                          if (formKey.currentState!.validate()) {
                            var code = controllerCode.text.toUpperCase();
                            var discount = state.percent;

                            cubit.addCoupom(code, discount);
                            Navigator.pop(context);
                          }
                        },
                        label: "Adicionar Cupom"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
