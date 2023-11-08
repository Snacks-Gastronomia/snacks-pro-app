import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/withdraw_service.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/withdraw_input.dart';

class WithdrawContent extends StatelessWidget {
  WithdrawContent({super.key});
  final WithdrawService withdrawService = WithdrawService();
  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            color: Colors.black,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Retirada",
                      style: AppTextStyles.bold(22, color: Colors.white),
                    ),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    StreamBuilder<Object>(
                        stream: withdrawService.getWithdrawCountStream(),
                        builder: (context, snapshot) {
                          return Flexible(
                            flex: 2,
                            child: ListTile(
                              title: Text(
                                'Quantidade',
                                style: AppTextStyles.regular(16,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                "${snapshot.data}",
                                style:
                                    AppTextStyles.bold(28, color: Colors.white),
                              ),
                            ),
                          );
                        }),
                    StreamBuilder<Object>(
                        stream: withdrawService.getWithdrawAmountSumStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var total = NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$')
                                .format(snapshot.data);
                            return Flexible(
                              flex: 3,
                              child: ListTile(
                                title: Text(
                                  'Total',
                                  style: AppTextStyles.regular(16,
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  total,
                                  style: AppTextStyles.bold(28,
                                      color: Colors.white),
                                ),
                              ),
                            );
                          } else {
                            return const Text("0");
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                children: [
                  Text(
                    DateFormat.yMMM("pt_BR").format(DateTime.now()),
                    style: AppTextStyles.regular(22),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                    stream: withdrawService.getWithdrawsByMonth(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('Nenhum dado disponível.');
                      } else {
                        return SizedBox(
                          height: 330,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var withdrawData = snapshot.data![index];
                              var timestamp =
                                  withdrawData['timestamp'] as DateTime;
                              var formattedTimestamp =
                                  DateFormat('dd/MM/yyyy - HH:mm')
                                      .format(timestamp);
                              var amount = withdrawData['amount'];
                              var formattedAmount = NumberFormat.currency(
                                      locale: 'pt_BR', symbol: 'R\$')
                                  .format(amount);

                              return Dismissible(
                                key: Key('$timestamp'),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await withdrawService
                                      .deleteWithdraw(timestamp);
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(formattedTimestamp),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0F6F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      AppImages.snacks_logo,
                                      color: Colors.black,
                                      width: 50,
                                    ),
                                  ),
                                  trailing: Text(
                                    formattedAmount,
                                    style: AppTextStyles.medium(16,
                                        color: AppColors.highlight),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  CustomSubmitButton(
                    onPressedAction: () async {
                      double result = await modal.showModalBottomSheet(
                        context: context,
                        content: const WithdrawInput(),
                      );
                      await withdrawService.createWithdraw(result);
                    },
                    label: 'Nova Retirada',
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
