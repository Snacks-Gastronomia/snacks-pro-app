import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snacks_pro_app/services/new_stock.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/repository/stock_repository.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final repository = StockRepository();
  final stockService = StockServiceApi();
  final storage = AppStorage();
  StockCubit() : super(StockState.initial());

  void onChangeState({
    String? title,
    String? document,
    String? unit,
    String? volume,
    String? date,
    String? time,
    String? value,
    String? description,
  }) {
    emit(state.copyWith(
      title: title ?? state.title,
      document: document ?? state.document,
      unit: unit ?? state.unit,
      volume: volume ?? state.volume,
      date: date ?? state.date,
      time: time ?? state.time,
      value: value ?? state.value,
      description: description ?? state.description,
    ));
  }

  // void changeTitle(String value) {
  //   emit(state.copyWith(title: value));
  // }

  // void clear() {
  //   emit(state.copyWith(
  //       doc: "", title: "", volume: "", unit: "", status: AppStatus.initial));
  // }

  // void updateState(item, id) {
  //   emit(state.copyWith(
  //       title: item["title"],
  //       volume: item["volume"].toString(),
  //       unit: item["unit"],
  //       doc: id,
  //       status: AppStatus.editing));
  // }

  // void changeSelected(Map value) {
  //   if (state.selected["doc"] == value["doc"]) {
  //     emit(state.copyWith(selected: {}));
  //   } else {
  //     emit(state.copyWith(selected: value));
  //   }
  // }

  // void notEmptyStock() {
  //   emit(state.copyWith(isEmpty: false));
  // }

  // void changeVolume(String value) {
  //   emit(state.copyWith(volume: value));
  // }

  // void changeUnit(String value) {
  //   emit(state.copyWith(unit: value));
  // }

  Future<void> save(bool isNew, {String? lastEntranceId}) async {
    try {
      var user = await storage.getDataStorage("user");
      var rid = user["restaurant"]["id"];
      emit(state.copyWith(created_at: DateTime.now(), title: state.title));

      if (isNew) {
        await stockService.newStockEntrance(rid, state.toMap());
      } else {
        var stock = state.selected.id;
        var consume = state.selected.consumed;
        var loss = state.selected.losses;
        var total = state.selected.total;

        emit(state.copyWith(title: state.selected.title));

        if (lastEntranceId != null) {
          await stockService.newStockEntrance(rid, state.toMap(),
              stockItemId: stock,
              pastConsume: double.parse(consume.toString()),
              pastLoss: double.parse(loss.toString()),
              pastTotal: double.parse(total.toString()),
              entranceId: lastEntranceId);
        } else {
          print("no last entrance id");
        }
      }
    } catch (e) {
      print("error: $e");
    }
  }

  Future<void> saveLoss() async {
    var user = await storage.getDataStorage("user");
    var rid = user["restaurant"]["id"];
    var stock = state.selected.id;

    emit(state.copyWith(created_at: DateTime.now(), unit: state.selected.unit));

    await stockService.newStockLoss(rid, stock, state.toMapLoss());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetch() async* {
    var user = await storage.getDataStorage("user");
    var restId = user["restaurant"]["id"];
    yield* repository.fetchStock(restId);
  }

  Future<void> selectStockItem(ItemStock data) async {
    emit(state.copyWith(selected: data));
    print("selected: ${state.selected.title}");
  }

  Future<void> deleteStockItem() async {
    try {
      var rid = await getRestaurantId();
      await stockService.deleteStock(rid, state.selected.id);
    } catch (e) {
      print("error: $e");
    }
  }

  getRestaurantId() async {
    var user = await storage.getDataStorage("user");
    return user["restaurant"]["id"];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchStockItems() async* {
    yield* stockService.fetchStock(await getRestaurantId());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStockConsume(
      rid, sid) async {
    return await stockService.getConsume(rid, sid);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStockLoss(rid, sid) async {
    return await stockService.getLoss(rid, sid);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStockAllLoss() async {
    var rid = await getRestaurantId();
    var sid = state.selected.id;
    return await stockService.getLoss(rid, sid, limit: 50);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStockAllConsume() async {
    var rid = await getRestaurantId();
    var sid = state.selected.id;
    return await stockService.getConsume(rid, sid, limit: 50);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchStockEntrances(
      rid, sid) async {
    return await stockService.getEntrances(rid, sid);
  }

  Future<dynamic> fetchScreenData(String id) async {
    var rid = await getRestaurantId();
    var stock = id;

    var futures = await Future.wait([
      fetchStockEntrances(rid, stock),
      fetchStockConsume(rid, stock),
      fetchStockLoss(rid, stock)
    ]);

    return {
      "entrances": futures[0].docs,
      "consume": futures[1].docs,
      "losses": futures[2].docs,
      "totalValue": state.selected.total,
      "consumedValue": state.selected.consumed,
      "lossValue": state.selected.losses,
    };
  }
}
