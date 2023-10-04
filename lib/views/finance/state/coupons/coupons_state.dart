import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';

abstract class CouponsState {}

class CouponsLoading extends CouponsState {}

class CouponsLoaded extends CouponsState {
  final List<CouponsModel> couponsList;
  CouponsLoaded(this.couponsList);
}

class CouponsError extends CouponsState {
  final String message;
  CouponsError(this.message);
}
