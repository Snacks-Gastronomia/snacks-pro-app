import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:snacks_pro_app/models/bank_model.dart';
import 'package:snacks_pro_app/services/finance_service.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/repository/finance_repository.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

part 'finance_home_state.dart';

class FinanceCubit extends Cubit<FinanceHomeState> {
  final storage = AppStorage();

  final repository = FinanceRepository(services: FinanceApiServices());
  FinanceCubit() : super(FinanceHomeState.initial()) {
    fetchBanks();
  }

  void fetchData() async {
    emit(state.copyWith(status: AppStatus.loading));
    var id = (await storage.getDataStorage("user"))["restaurant"]["id"];

    var data = await Future.wait([
      repository.getMonthlyBudget(id),
      repository.fetchBankInformations(id),
    ]);
    print(data);
    emit(state.copyWith(
      status: AppStatus.loaded,
      budget: data[0],
      bankInfo: data[1],
      // employees_count: data[0],
      // orders_count: data[2]
    ));
  }

  void save(context) async {
    var id = (await storage.getDataStorage("user"))["restaurant"]["id"];
    await repository.addBankData(state.bankInfo.toMap(), id);
    Navigator.pop(context);
  }

  Future<List<String>> fetchBanks() async {
    List<String> items = (await repository.fetchBanks())
        .where((element) => element["code"] != null)
        .map<String>((e) => e["name"] + " - 0" + e["code"].toString())
        .toList();

    items.sort();

    return items;
    // .toList()
  }

  void changeBankAccount(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(account: value)));
    print(state);
  }

  void changeBankAgency(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(agency: value)));
    print(state);
  }

  void changeBankName(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(bank: value)));
    print(state);
  }

  void changeBankOwner(String value) {
    var bank = state.bankInfo;

    emit(state.copyWith(bankInfo: bank.copyWith(owner: value)));
    print(state);
  }
}
