import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/services/coupons_service.dart';

import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final service = CouponsService();

  CouponsCubit() : super(CouponsState.initial()) {
    service.getCoupons().then((data) {
      final couponsList = CouponsModel.fromData(data.docs);

      emit(state.copyWith(couponsList: couponsList));
    });
  }

  Future<void> addCoupom(String code, int discount) async {
    final coupom = CouponsModel.newCupom(code, discount);

    service.addCoupom(coupom);
    final data = await service.getCoupons();
    final couponsList = CouponsModel.fromData(data.docs);

    emit(state.copyWith(couponsList: couponsList));
  }

  Future<void> removeCoupom(CouponsModel coupom) async {
    service.removeCoupom(coupom);
    final data = await service.getCoupons();
    final couponsList = CouponsModel.fromData(data.docs);

    emit(state.copyWith(couponsList: couponsList));
  }

  Future<void> toggleActive(CouponsModel coupom) async {
    await service.toggleValue(coupom);
    final data = await service.getCoupons();
    final couponsList = CouponsModel.fromData(data.docs);

    emit(state.copyWith(couponsList: couponsList));
  }

  void setPercent(String value) {
    var percent = int.parse(value);
    emit(state.copyWith(percent: percent));
  }

  void increment() {
    var percent = state.percent;
    percent < 99 ? percent += 1 : null;
    emit(state.copyWith(percent: percent));
  }

  void decrement() {
    var percent = state.percent;
    percent > 0 ? percent -= 1 : null;
    emit(state.copyWith(percent: percent));
  }
}
