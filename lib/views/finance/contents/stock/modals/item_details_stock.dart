import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/stock_bar_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/stock_pie_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/history_losses.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/history_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/itens_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/losses_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/widgets/common_button_stock.dart';

class ItemDetailsStock extends StatelessWidget {
  ItemDetailsStock({super.key, required this.item});
  final ItemStock item;
  final modal = AppModal();
  final stock = NewStockService();

  @override
  Widget build(BuildContext context) {
    String amount = '${item.amount} ${item.measure}';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => modal.showModalBottomSheet(
            context: context,
            content: AddStock(
              item: item,
              increment: true,
            )),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.black,
        child: Icon(Icons.refresh_rounded),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(item.title, style: AppTextStyles.regular(22))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Entradas",
                style: AppTextStyles.bold(22),
              ),
              const SizedBox(
                height: 15,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: ListTile(
                              title: const Text('Valor'),
                              subtitle: Text(NumberFormat.currency(
                                      locale: "pt", symbol: r"R$ ")
                                  .format(item.value)),
                            ),
                          ),
                          Flexible(
                            child: ListTile(
                                title: const Text('Quantidade'),
                                subtitle: Text(amount)),
                          ),
                        ],
                      ),
                      ListTile(
                        title: const Text('Documento'),
                        subtitle: Text('${item.document}'),
                      ),
                      ListTile(
                        title: const Text('Descrição'),
                        subtitle: Text(item.description),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              StockPieChart(
                item: item,
              ),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                shape: const BorderDirectional(
                    start: BorderSide(width: 10, color: Color(0xffD9D9D9))),
                title: Text(
                  "Consumo",
                  style: AppTextStyles.bold(18),
                ),
                trailing: Text('${item.consume}${item.measure}'),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: FutureBuilder(
                  future: stock.getItemLossesCollection(item: item.title),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Ou qualquer indicador de carregamento que você preferir
                    } else if (stream.hasError) {
                      return Text('Erro: ${stream.error}');
                    } else if (!stream.hasData) {
                      return const Center(child: Text('Sem dados'));
                    } else {
                      var docs = stream.data!;
                      List<LossesStock> losses = docs
                          .map((e) => LossesStock.fromMap(e.data()))
                          .toList();
                      for (var losse in losses) {
                        debugPrint(losse.toMap().toString());
                      }

                      return const StockBarChart();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CommonButtonStock(
                label: 'Histórico de pedidos',
                icon: Icons.arrow_forward_ios_rounded,
                action: () => modal.showModalBottomSheet(
                    context: context,
                    content: HistoryStock(
                      item: item,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButtonStock(
                label: 'Itens',
                icon: Icons.arrow_forward_ios_rounded,
                action: () => modal.showModalBottomSheet(
                    context: context,
                    content: ItensStock(
                      item: item,
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              ListTile(
                shape: const BorderDirectional(
                    start: BorderSide(width: 10, color: Color(0xffD9D9D9))),
                title: Text(
                  "Perdas",
                  style: AppTextStyles.bold(18),
                ),
                trailing: Text('${item.losses}${item.measure}'),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: FutureBuilder(
                  future: stock.getItemLossesCollection(item: item.title),
                  builder: (context, stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                              CircularProgressIndicator()); // Ou qualquer indicador de carregamento que você preferir
                    } else if (stream.hasError) {
                      return Text('Erro: ${stream.error}');
                    } else if (!stream.hasData) {
                      return const Center(child: Text('Sem dados'));
                    } else {
                      var docs = stream.data!;
                      List<LossesStock> losses = docs
                          .map((e) => LossesStock.fromMap(e.data()))
                          .toList();
                      for (var losse in losses) {
                        debugPrint(losse.toMap().toString());
                      }

                      return const StockBarChart();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButtonStock(
                label: 'Histórico de perdas',
                icon: Icons.arrow_forward_ios_rounded,
                action: () => modal.showModalBottomSheet(
                    context: context,
                    content: HistoryLosses(
                      item: item,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonButtonStock(
                label: 'Adicionar perda',
                icon: Icons.add,
                color: Colors.blue,
                textColor: Colors.white,
                action: () => modal.showModalBottomSheet(
                    context: context,
                    content: AddStock(
                      item: item,
                      losses: true,
                    )),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
