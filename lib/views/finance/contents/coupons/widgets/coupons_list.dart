import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/coupons_service.dart';

import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_cubit.dart';

class CouponsList extends StatelessWidget {
  CouponsList({
    super.key,
    required this.couponsList,
  });
  final List<CouponsModel> couponsList;

  final service = CouponsService();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: couponsList.length,
      itemBuilder: (context, index) {
        CouponsModel coupom = couponsList[index];
        final cubit = context.read<CouponsCubit>();
        final textDiscount = 'Desconto: ${coupom.discount} %';
        return ListTile(
          title: Text(
            coupom.code,
            style: AppTextStyles.semiBold(20),
          ),
          subtitle: Text(
            textDiscount,
            style: AppTextStyles.config(14, color: Colors.green),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(children: [
              IconButton(
                  onPressed: () => cubit.toggleActive(coupom),
                  icon: Icon(
                    coupom.active
                        ? Icons.lock_open_outlined
                        : Icons.lock_outline,
                    color: Colors.black,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () => cubit.removeCoupom(coupom),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 30,
                  )),
            ]),
          ),
        );
      },
    );
  }
}
