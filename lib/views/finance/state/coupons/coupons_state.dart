import 'package:flutter/foundation.dart';
import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';

class CouponsState {
  final List<CouponsModel>? couponsList;
  final int percent;

  CouponsState({
    required this.couponsList,
    required this.percent,
  });

  factory CouponsState.initial() => CouponsState(couponsList: null, percent: 0);

  CouponsState copyWith({List<CouponsModel>? couponsList, int? percent}) {
    return CouponsState(
        couponsList: couponsList ?? this.couponsList,
        percent: percent ?? this.percent);
  }
}
