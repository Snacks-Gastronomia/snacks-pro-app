import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_cubit.dart';

class AddCupom extends StatelessWidget {
  const AddCupom({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerCode = TextEditingController();
    TextEditingController controllerDiscount = TextEditingController();
    final cubit = context.read<CouponsCubit>();

    return Padding(
      padding: const EdgeInsets.all(30.0),
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
          ),
          const SizedBox(
            height: 13,
          ),
          TextFormField(
            controller: controllerDiscount,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                hintText: "Desconto",
                filled: true,
                fillColor: Colors.black12),
          ),
          const SizedBox(
            height: 36,
          ),
          CustomSubmitButton(
              onPressedAction: () {
                var code = controllerCode.text;
                var discount = int.parse(controllerDiscount.text);

                cubit.addCoupom(code, discount);
                Navigator.pop(context);
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
    );
  }
}
