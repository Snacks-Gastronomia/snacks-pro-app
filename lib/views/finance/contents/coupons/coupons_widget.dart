import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/modal/add_cupom.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/widgets/coupons_list.dart';

import '../../../../core/app.text.dart';

class CouponsWidget extends StatelessWidget {
  CouponsWidget({super.key});

  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cupons",
              style: AppTextStyles.semiBold(22),
            ),
            const SizedBox(
              height: 25,
            ),
            const CouponsList(),
            const SizedBox(
              height: 25,
            ),
            TextButton(
                onPressed: () {
                  modal.showModalBottomSheet(
                      context: context, content: const AddCupom());
                },
                child: const Text('Adicionar cupom')),
            const Spacer(),
            CustomSubmitButton(
                onPressedAction: () {
                  Navigator.pop(context);
                },
                label: "OK")
          ],
        ),
      ),
    ));
  }
}
