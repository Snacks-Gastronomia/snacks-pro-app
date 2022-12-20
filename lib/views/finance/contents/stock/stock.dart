import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/add_item.dart';
import 'package:snacks_pro_app/views/finance/repository/stock_repository.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

class StockScreen extends StatelessWidget {
  StockScreen({super.key});
  final modal = AppModal();
  final stockRepo = StockRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomeCubit>(context),
      child: Scaffold(
        key: UniqueKey(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => modal.showModalBottomSheet(
              withPadding: false, context: context, content: AddStockScreen()),
          backgroundColor: Colors.black,
          tooltip: "Adicionar item",
          child: const Center(
            child: Icon(Icons.add_rounded),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Estoque',
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // color: Colors.black,
                  height: 200,
                  child: Center(
                      child: BlocBuilder<StockCubit, StockState>(
                          key: UniqueKey(),
                          builder: (context, snapshot) {
                            if (snapshot.selected.isNotEmpty) {
                              final item = snapshot.selected;
                              final roundedValue =
                                  int.parse(item["data"]["current"].toString())
                                      .ceil();
                              return SleekCircularSlider(
                                onChangeEnd: (double value) {
                                  context.read<StockCubit>().updateVolume(
                                      context
                                          .read<HomeCubit>()
                                          .state
                                          .storage["restaurant"]["id"],
                                      value.ceil().toInt());
                                },

                                innerWidget: (percentage) {
                                  final roundedValue =
                                      percentage.ceil().toInt();
                                  return Center(
                                      child: Text(
                                    '$roundedValue ${item["data"]["unit"]}',
                                    style: AppTextStyles.semiBold(35,
                                        color: Colors.black),
                                  ));
                                },
                                appearance: CircularSliderAppearance(
                                    size: 200,
                                    customWidths: CustomSliderWidths(
                                        progressBarWidth: 25,
                                        trackWidth: 25,
                                        handlerSize: 7),
                                    customColors: CustomSliderColors(
                                        dotColor: Colors.white,
                                        hideShadow: false,
                                        shadowMaxOpacity: 0,
                                        trackColor: Colors.grey.shade200,
                                        progressBarColor: Colors.black)),
                                min: 0,
                                max: roundedValue
                                    .toDouble(), //quantidade - item_volume;
                                // initialValue: double.parse(roundedValue.toString()),
                                initialValue: roundedValue.toDouble(),
                              );
                            } else if (!snapshot.isEmpty) {
                              return Center(
                                  child: Text(
                                "Selecione um item",
                                style: AppTextStyles.light(24,
                                    color: const Color(0xffBFBFBF)),
                              ));
                            } else {
                              return const SizedBox();
                            }
                            // })),
                          })),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Expanded(
                  child: ListItems(
                      modal: modal,
                      fetch: stockRepo.fetchStock(context
                          .read<HomeCubit>()
                          .state
                          .storage["restaurant"]["id"])),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({
    Key? key,
    required this.fetch,
    required this.modal,
  }) : super(key: key);
  final Stream<QuerySnapshot<Map<String, dynamic>>> fetch;
  final AppModal modal;
  @override
  Widget build(BuildContext context) {
    // var data = context.read<HomeCubit>().state.storage;
    // print(data);
    return StreamBuilder(
        stream: fetch,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // context.read<EmployeesCubit>().convertData(snapshot.data!);
            print("calling again");
            // print(snapshot.data!.docs.length);
            if (snapshot.data!.docs.isEmpty) {
              return Text(
                "Estoque não adicionado",
                style: AppTextStyles.light(24, color: const Color(0xffBFBFBF)),
              );
            } else {
              context.read<StockCubit>().notEmptyStock();
              return BlocBuilder<StockCubit, StockState>(
                  builder: (context, state) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xffE7E7E7),
                  ),
                  // itemCount: snapshot.data!.docs.length,
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var element = snapshot.data!.docs[index];
                    return Slidable(
                        key: const ValueKey(0),
                        enabled: (state.selected["doc"] == element.id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.4,
                          children: [
                            CustomSlidableAction(
                              onPressed: (context) {},
                              autoClose: true,
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<StockCubit>().updateState(
                                          element.data(), element.id);
                                      modal.showModalBottomSheet(
                                          withPadding: false,
                                          context: context,
                                          content: const AddStockScreen());
                                    },
                                    child: const Text(
                                      "Atualizar",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        child: SizedBox(
                            height: 65,
                            child: GestureDetector(
                              onTap: () => context
                                  .read<StockCubit>()
                                  .changeSelected({
                                "data": element.data(),
                                "doc": element.id
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: state.selected.isNotEmpty &&
                                            state.selected["doc"] == element.id
                                        ? Colors.grey.shade100
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          element.data()["title"],
                                          style: AppTextStyles.semiBold(18,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '${element.data()["volume"]} ${element.data()["unit"]}',
                                          style: AppTextStyles.light(12,
                                              color: const Color(0xffB3B3B3)),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${element.data()["current"]} ${element.data()["unit"]}',
                                      style: AppTextStyles.semiBold(18,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                                // selectedTileColor: Colors.grey.shade300,
                                // selected: true,
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(8)),
                                // contentPadding: EdgeInsets.all(5),
                                // trailing: Text("20 KG")),
                              ),
                            )));
                  },
                );
              });
            }
          }
          return const CustomCircularProgress();
        });
  }
}
