import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/conference/controllers/conference_controller.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';
import 'package:snacks_pro_app/views/conference/services/conference_service.dart';

class ModalConferenceAdm extends StatelessWidget {
  const ModalConferenceAdm({super.key, required this.conferenceModelCaixa});

  final ConferenceModel conferenceModelCaixa;

  @override
  Widget build(BuildContext context) {
    final controller = ConferenceController();
    final service = ConferenceService();
    return Padding(
      padding: const EdgeInsets.all(32),
      child: FutureBuilder(
        future: service.getConferenceSistema(conferenceModelCaixa.date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: const [
                SizedBox(
                  height: 50,
                ),
                CustomCircularProgress(),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Carregando conferência do sistema...',
                ),
                Text(
                  'Isso pode levar alguns minutos',
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar conferência!',
                style: AppTextStyles.bold(20),
              ),
            );
          } else {
            var conferenceModelSistema = snapshot.data as ConferenceModel;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conferenceModelSistema.dateFormat,
                  style: AppTextStyles.semiBold(26),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //coluna do sistema
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Dinheiro',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Sistema',
                        ),
                        Text(
                          conferenceModelSistema.dinheiroFormat,
                          style: AppTextStyles.bold(20,
                              color: controller.colorTotal(
                                  valueOne: conferenceModelSistema.dinheiro,
                                  valueTwo: conferenceModelCaixa.dinheiro)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Pix',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Sistema',
                        ),
                        Text(
                          conferenceModelSistema.pixFormat,
                          style: AppTextStyles.bold(
                            20,
                            color: controller.colorTotal(
                                valueOne: conferenceModelSistema.pix,
                                valueTwo: conferenceModelCaixa.pix),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Cartão de Credito',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Sistema',
                        ),
                        Text(
                          conferenceModelSistema.creditoFormat,
                          style: AppTextStyles.bold(20,
                              color: controller.colorTotal(
                                  valueOne: conferenceModelSistema.credito,
                                  valueTwo: conferenceModelCaixa.credito)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Cartão de Débito',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Sistema',
                        ),
                        Text(
                          conferenceModelSistema.debitoFormat,
                          style: AppTextStyles.bold(
                            20,
                            color: controller.colorTotal(
                                valueOne: conferenceModelSistema.debito,
                                valueTwo: conferenceModelCaixa.debito),
                          ),
                        ),
                      ],
                    ),
                    //coluna do caixa
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text('Caixa'),
                        Text(
                          conferenceModelCaixa.totalFormat,
                          style: AppTextStyles.bold(
                            20,
                            color: controller.colorTotal(
                              valueOne: conferenceModelCaixa.total,
                              valueTwo: conferenceModelSistema.total,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text('Caixa'),
                        Text(
                          conferenceModelCaixa.pixFormat,
                          style: AppTextStyles.bold(20,
                              color: controller.colorTotal(
                                  valueOne: conferenceModelCaixa.pix,
                                  valueTwo: conferenceModelSistema.pix)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text('Caixa'),
                        Text(
                          conferenceModelCaixa.creditoFormat,
                          style: AppTextStyles.bold(
                            20,
                            color: controller.colorTotal(
                                valueOne: conferenceModelCaixa.credito,
                                valueTwo: conferenceModelSistema.credito),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const Text('Caixa'),
                        Text(
                          conferenceModelCaixa.debitoFormat,
                          style: AppTextStyles.bold(
                            20,
                            color: controller.colorTotal(
                                valueOne: conferenceModelCaixa.debito,
                                valueTwo: conferenceModelSistema.debito),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total caixa',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      conferenceModelCaixa.totalFormat,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total sistema',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      conferenceModelSistema.totalFormat,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    fixedSize: const Size(double.maxFinite, 59),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('Fechar'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
