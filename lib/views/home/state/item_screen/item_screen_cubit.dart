import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_pro_app/models/item_model.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/services/items_service.dart';
import 'package:snacks_pro_app/views/home/repository/items_repository.dart';

part 'item_screen_state.dart';

class ItemScreenCubit extends Cubit<ItemScreenState> {
  ItemScreenCubit() : super(ItemScreenState.initial());
  void incrementAmount() {
    var amount = state.order!.amount + 1;

    emit(state.copyWith(order: state.order!.copyWith(amount: amount)));
    print(state.order!.amount);
  }

  void decrementAmount() {
    var amount = state.order!.amount;
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

  getNewValue() {
    return state.order!.item.value * state.order!.amount;
  }
}
