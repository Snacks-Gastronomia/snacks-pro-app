import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/services/coupons_service.dart';

import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final List<CouponsModel> coupons;

  final service = CouponsService();

  CouponsCubit()
      : coupons = [],
        super(CouponsLoading()) {
    service.getCoupons().then((data) {
      final couponsList = CouponsModel.fromData(data.docs);
      coupons.addAll(couponsList);
      emit(CouponsLoaded(coupons));
    });
  }
  Future<void> addCoupom(String code, int discount) async {
    emit(CouponsLoading());
    final coupom = CouponsModel.newCupom(code, discount);

    service.addCoupom(coupom);
    final data = await service.getCoupons();
    final couponsList = CouponsModel.fromData(data.docs);
    emit(CouponsLoaded(couponsList));
  }

  Future<void> removeCoupom(CouponsModel coupom) async {
    emit(CouponsLoading());

    service.removeCoupom(coupom);
    final data = await service.getCoupons();
    final couponsList = CouponsModel.fromData(data.docs);
    emit(CouponsLoaded(couponsList));
  }
}
