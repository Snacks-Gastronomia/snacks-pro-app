import 'package:snacks_pro_app/views/finance/contents/coupons/model/coupons_model.dart';

abstract class CouponsState {}

class CouponsInital extends CouponsState {}

class CouponsLoading extends CouponsState {}

class CounponsLoaded extends CouponsState {
  final List<CouponsModel> couponsList;
  CounponsLoaded(this.couponsList);
}

class CounponsError extends CouponsState {
  final String message;
  CounponsError(this.message);
}
