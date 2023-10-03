import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/coupons_service.dart';

import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';

class CouponsList extends StatefulWidget {
  const CouponsList({super.key});

  @override
  State<CouponsList> createState() => _CouponsListState();
}

class _CouponsListState extends State<CouponsList> {
  final service = CouponsService();
  final storage = AppStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: service.getCoupons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;

            List<CouponsModel> couponsList = CouponsModel.fromData(data);

            return ListView.builder(
              shrinkWrap: true,
              itemCount: couponsList.length,
              itemBuilder: (context, index) {
                CouponsModel coupom = couponsList[index];
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
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
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
