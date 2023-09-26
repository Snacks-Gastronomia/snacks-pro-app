import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/models/order_model.dart';

part 'item_screen_state.dart';

class ItemScreenCubit extends Cubit<ItemScreenState> {
  ItemScreenCubit() : super(ItemScreenState.initial());
  void incrementAmount() {
    var amount = state.order?.amount ?? 1;
    amount += 1;

    emit(state.copyWith(order: state.order?.copyWith(amount: amount)));
    print(state.order?.amount);
  }

  void decrementAmount() {
    var amount = state.order?.amount ?? 1;
    if (amount != 1) {
      amount--;
      emit(state.copyWith(order: state.order!.copyWith(amount: amount)));
    }
  }

  void observationChanged(String obs) {
    emit(state.copyWith(order: state.order!.copyWith(observations: obs)));
    print(state);
  }

  void insertItem(OrderModel order, bool isNew) {
    emit(state.copyWith(order: order, isNew: isNew));
    print(state);
  }

  // getNewValue() {
  //   return state.order!.item.value * state.order!.amount;
  // }
}
