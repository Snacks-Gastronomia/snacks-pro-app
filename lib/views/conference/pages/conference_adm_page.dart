import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.text.dart';

class ConferenceAdmPage extends StatelessWidget {
  const ConferenceAdmPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
