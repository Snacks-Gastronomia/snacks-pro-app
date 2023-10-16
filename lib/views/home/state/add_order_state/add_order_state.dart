import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/utils/enums.dart';

import '../../../../models/order_model.dart';

class AddOrderState {
  final AppStatus status;
  final OrderModel order;

  AddOrderState(this.status, this.order);

  factory AddOrderState.inital() => AddOrderState(
      AppStatus.initial,
      OrderModel(
          item: Item(
              title: '',
              value: 0,
              discount: 0,
              finalValue: 0,
              num_served: 0,
              time: 0,
              restaurant_id: '',
              restaurant_name: '',
              active: false),
          option_selected: '',
          observations: ''));
}
