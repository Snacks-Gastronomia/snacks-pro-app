import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';
import 'package:snacks_pro_app/views/finance/state/coupons/coupons_state.dart';

class CouponsCubit extends Cubit<CouponsState> {
  final List<CouponsModel> _coupons = [];
  List<CouponsModel> get coupons => _coupons;

  CouponsCubit() : super(CouponsInital());

  Future<void> addCoupom(CouponsModel coupom) async {
    emit(CouponsLoading());

    if (_coupons.contains(coupom)) {
      emit(CounponsError("Esse cupom já existe"));
    } else {
      _coupons.add(coupom);
      emit(CounponsLoaded(_coupons));
    }
  }

  Future<void> removeCoupom(CouponsModel coupom) async {
    emit(CouponsLoading());

    _coupons.remove(coupom);
    emit(CounponsLoaded(_coupons));
  }
}
