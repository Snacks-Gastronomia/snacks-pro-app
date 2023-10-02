import 'package:flutter/material.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';

class CouponsList extends StatefulWidget {
  const CouponsList({super.key});

  @override
  State<CouponsList> createState() => _CouponsListState();
}

class _CouponsListState extends State<CouponsList> {
  CouponsModel coupom =
      CouponsModel(active: true, code: "FELIZNIVER10", discount: 10);

  @override
  Widget build(BuildContext context) {
    final List<CouponsModel> couponsList = [coupom];
    return ListView.builder(
      itemCount: couponsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(coupom.code),
        );
      },
    );
  }
}
