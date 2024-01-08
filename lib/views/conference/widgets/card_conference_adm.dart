import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.colors.dart';
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
    return Card(
      elevation: 0,
      color: Colors.grey[200],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              conferenceModel.dateFormat,
              style: AppTextStyles.bold(16),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.check,
                  color: AppColors.highlight,
                  size: 14,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  conferenceModel.totalFormat,
                  style: TextStyle(
                    height: 2,
                    color: AppColors.highlight,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.blue[400],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
