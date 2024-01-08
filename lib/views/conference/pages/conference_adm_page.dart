import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/conference/modals/modal_conference_adm.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';
import 'package:snacks_pro_app/views/conference/services/conference_service.dart';
import 'package:snacks_pro_app/views/conference/widgets/card_conference_adm.dart';

class ConferenceAdmPage extends StatelessWidget {
  const ConferenceAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ConferenceService();
    final modal = AppModal();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(),
                Text(
                  'Conferências',
                  style: AppTextStyles.bold(25),
                ),
                const Spacer(),
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 44,
            ),
            Row(
              children: [
                const Text('ultimos 7 dias'),
                const Spacer(),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.calendar_today))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: service.getConferenceTeste(),
              builder: (context, future) {
                if (future.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CustomCircularProgress(),
                  );
                } else if (future.hasData) {
                  List<ConferenceModel> conferences = future.data!;
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: conferences.length,
                      itemBuilder: (context, index) {
                        return CardConferenceAdm(
                          conferenceModel: conferences[index],
                          onTap: () {
                            modal.showModalBottomSheet(
                              context: context,
                              content: ModalConferenceAdm(
                                  conferenceModelCaixa:
                                      service.store.conferenceModelMock,
                                  conferenceModelSistema: conferences[index]),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (future.hasError) {
                  return Text('Erro ao carregar conferências! ${future.error}');
                } else {
                  return const Center(
                    child: Text('Nenhuma conferência encontrada!'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
