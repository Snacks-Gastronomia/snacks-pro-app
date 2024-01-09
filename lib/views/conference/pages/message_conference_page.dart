import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/conference/services/conference_service.dart';

class MessageConferencePage extends StatelessWidget {
  const MessageConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ConferenceService service = ConferenceService();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: FutureBuilder(
            future: service.verifyConference(),
            builder: (context, future) {
              bool isClose = future.data ?? false;
              if (future.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomCircularProgress());
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.pie_chart,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Conferência',
                      style: AppTextStyles.bold(20),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Proceso direcionado ao período \ndas 11hrs até às 02hrs. ',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    isClose
                        ? Container(
                            width: double.maxFinite,
                            height: 59,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Conferência concluída!',
                                style: AppTextStyles.regular(16),
                              ),
                            ),
                          )
                        : CustomSubmitButton(
                            label: 'Iniciar Processo',
                            onPressedAction: () {
                              Navigator.pushNamed(context, '/conference');
                            },
                          )
                  ],
                );
              }
            }),
      ),
    );
  }
}
