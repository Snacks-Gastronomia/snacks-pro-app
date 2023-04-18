import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/stock_repository.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final repository = StockRepository();
  final storage = AppStorage();
  StockCubit() : super(StockState.initial());

  void changeTitle(String value) {
    emit(state.copyWith(title: value));
  }

  void clear() {
    emit(state.copyWith(
        doc: "", title: "", volume: "", unit: "", status: AppStatus.initial));
  }

  void updateState(item, id) {
    emit(state.copyWith(
        title: item["title"],
        volume: item["volume"].toString(),
        unit: item["unit"],
        doc: id,
        status: AppStatus.editing));
  }

  void changeSelected(Map value) {
    if (state.selected["doc"] == value["doc"]) {
      emit(state.copyWith(selected: {}));
    } else {
      emit(state.copyWith(selected: value));
    }
  }

  void notEmptyStock() {
    emit(state.copyWith(isEmpty: false));
  }

  void changeVolume(String value) {
    emit(state.copyWith(volume: value));
  }

  void changeUnit(String value) {
    emit(state.copyWith(unit: value));
  }

  save() async {
    var user = await storage.getDataStorage("user");
    var rest_id = user["restaurant"]["id"];
    if (state.status == AppStatus.editing) {
      updateData();
    } else {}
    repository.addStockItem(rest_id, state.toMap());
  }

  updateData() async {
    var user = await storage.getDataStorage("user");
    var rest_id = user["restaurant"]["id"];
    var value = int.parse(state.volume.toString());
    var data = {
      "volume": FieldValue.increment(value),
      "current": FieldValue.increment(value)
    };
    repository.updateStock(rest_id, state.doc, data);
    clear();
  }

  updateVolume(volume) async {
    var user = await storage.getDataStorage("user");
    var rest_id = user["restaurant"]["id"];
    var value = int.parse(volume.toString());
    var data = {"current": value};
    repository.updateStockItem(rest_id, state.selected["doc"], data);
    // repository.addStockItem(restaurant_id, state.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetch() async* {
    var user = await storage.getDataStorage("user");
    var rest_id = user["restaurant"]["id"];
    yield* repository.fetchStock(rest_id);
  }
}
