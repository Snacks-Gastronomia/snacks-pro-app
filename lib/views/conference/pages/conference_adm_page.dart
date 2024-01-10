import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/conference/modals/modal_conference_adm.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';
import 'package:snacks_pro_app/views/conference/services/conference_service.dart';
import 'package:snacks_pro_app/views/conference/store/conference_store.dart';
import 'package:snacks_pro_app/views/conference/widgets/card_conference_adm.dart';

class ConferenceAdmPage extends StatelessWidget {
  const ConferenceAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ConferenceService();
    final modal = AppModal();
    final store = ConferenceStore();

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
                    onPressed: () async {
                      store.listDateTime = (await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                                firstDate: DateTime(2022),
                                calendarType: CalendarDatePicker2Type.range),
                            dialogSize: const Size(325, 400),
                            borderRadius: BorderRadius.circular(15),
                          )) ??
                          [];
                      debugPrint(store.listDateTime.toString());
                    },
                    icon: const Icon(Icons.calendar_today))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedBuilder(
              animation: store.listDateTimeNotifier,
              builder: (context, _) => FutureBuilder(
                future: service.getConferences(
                    startDay: store.listDateTime.isEmpty
                        ? null
                        : store.listDateTime[0],
                    endDay: store.listDateTime.length != 2
                        ? null
                        : store.listDateTime[1]),
                builder: (context, future) {
                  if (future.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CustomCircularProgress(),
                      ),
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
                                    conferenceModelCaixa: conferences[index]),
                              );
                            },
                          );
                        },
                      ),
                    );
                  } else if (future.hasError) {
                    return Text(
                        'Erro ao carregar conferências! ${future.error}');
                  } else {
                    return const Center(
                      child: Text('Nenhuma conferência encontrada!'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
