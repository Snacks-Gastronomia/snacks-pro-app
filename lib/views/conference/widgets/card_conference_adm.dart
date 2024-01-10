import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/conference/models/conference_model.dart';

class CardConferenceAdm extends StatelessWidget {
  const CardConferenceAdm({
    super.key,
    required this.conferenceModel,
    required this.onTap,
  });
  final ConferenceModel conferenceModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isObscure = ValueNotifier(true);

    void toogleObscure() {
      isObscure.value = !isObscure.value;
    }

    return Card(
      elevation: 0,
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AnimatedBuilder(
            animation: isObscure,
            builder: (context, _) {
              return ListTile(
                title: Text(
                  conferenceModel.dateFormat,
                  style: AppTextStyles.bold(16),
                ),
                subtitle: isObscure.value
                    ? Text(
                        conferenceModel.totalFormat,
                        style: const TextStyle(
                          height: 2,
                        ),
                      )
                    : const Text('--'),
                trailing: IconButton(
                  onPressed: () => toogleObscure(),
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.blue[400],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
