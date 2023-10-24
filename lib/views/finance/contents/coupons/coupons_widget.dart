import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/services/coupons_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/modal/add_cupom.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/widgets/coupons_list.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_state.dart';

import '../../../../core/app.text.dart';
import '../../state/coupons/coupons_cubit.dart';
import 'model/coupons_model.dart';

class CouponsWidget extends StatefulWidget {
  const CouponsWidget({super.key});

  @override
  State<CouponsWidget> createState() => _CouponsWidgetState();
}

class _CouponsWidgetState extends State<CouponsWidget> {
  final modal = AppModal();

  final service = CouponsService();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CouponsCubit>();

    return BlocBuilder<CouponsCubit, CouponsState>(
        bloc: cubit,
        builder: (context, state) {
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
                  if (state.couponsList != null)
                    CouponsList(
                      couponsList: state.couponsList,
                    ),
                  if (state.couponsList == null)
                    const CircularProgressIndicator(),
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
        });
  }
}