import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/widgets/coupons_list.dart';

import '../../../../core/app.text.dart';

class CouponsWidget extends StatelessWidget {
  const CouponsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(
              "Cupons",
              style: AppTextStyles.semiBold(22),
            ),
            const SizedBox(
              height: 100,
              child: CouponsList(),
            ),
          ],
        ),
      ),
    ));
  }
}
