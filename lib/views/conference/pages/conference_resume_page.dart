import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/conference/controllers/conference_controller.dart';
import 'package:snacks_pro_app/views/conference/modals/modal_conference.dart';
import 'package:snacks_pro_app/views/conference/widgets/card_conference.dart';

class ConferenceResumePage extends StatelessWidget {
  const ConferenceResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppModal modal = AppModal();
    final ConferenceController controller = ConferenceController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          'Resumo',
          style: AppTextStyles.bold(25),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                  valueListenable: controller.store.totalDinheiro,
                  builder: (context, value, child) {
                    return CardConference(
                      title: 'Dinheiro',
                      total: value,
                      onTap: () {
                        modal.showModalBottomSheet(
                          context: context,
                          content: ModalConference(
                            title: 'Dinheiro',
                            subtitle:
                                'Valor correspondente ao total de pedidos no cartão de dinheiro',
                            textEditingController:
                                controller.store.dinheiroController,
                            onTap: () => controller.setTotalDinheiro(
                                controller.store.dinheiroController),
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                  valueListenable: controller.store.totalCredito,
                  builder: (context, value, child) {
                    return CardConference(
                      title: 'Cartão de crédito',
                      total: value,
                      onTap: () {
                        modal.showModalBottomSheet(
                          context: context,
                          content: ModalConference(
                            title: 'Cartão de crédito',
                            subtitle:
                                'Valor correspondente ao total de pedidos no cartão de crédito',
                            textEditingController:
                                controller.store.creditoController,
                            onTap: () => controller.setTotalCredit(
                                controller.store.creditoController),
                          ),
                        );
                      },
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                valueListenable: controller.store.totalDebito,
                builder: (context, value, child) {
                  return CardConference(
                    title: 'Cartão de débito',
                    total: value,
                    onTap: () {
                      modal.showModalBottomSheet(
                        context: context,
                        content: ModalConference(
                          title: 'Cartão de débito',
                          subtitle:
                              'Valor correspondente ao total de pedidos no cartão de débito',
                          textEditingController:
                              controller.store.debitoController,
                          onTap: () => controller.setTotalDebito(
                              controller.store.debitoController),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                valueListenable: controller.store.totalPix,
                builder: (context, value, child) {
                  return CardConference(
                    title: 'Pix',
                    total: value,
                    onTap: () {
                      modal.showModalBottomSheet(
                        context: context,
                        content: ModalConference(
                          title: 'Pix',
                          subtitle:
                              'Valor correspondente ao total de pedidos no pix',
                          textEditingController: controller.store.pixController,
                          onTap: () => controller
                              .setTotalPix(controller.store.pixController),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Total',
                style: AppTextStyles.bold(26),
              ),
              ValueListenableBuilder(
                  valueListenable: controller.store.total,
                  builder: (context, value, child) {
                    return Text(
                      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                          .format(value ?? 0),
                      style: AppTextStyles.regular(18),
                    );
                  }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: CustomSubmitButton(
          onPressedAction: () => controller.submitConference(context),
          label: 'Enviar',
        ),
      ),
    );
  }
}
