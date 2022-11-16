import 'package:flutter/material.dart';

import 'package:snacks_pro_app/core/app.text.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    Key? key,
    required this.onPressedAction,
    required this.label,
    this.loading_label = "",
    this.loading = false,
    this.dark_theme = false,
  }) : super(key: key);

  final VoidCallback onPressedAction;
  final String label;
  final String loading_label;
  final bool loading;
  final bool dark_theme;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressedAction,
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: dark_theme ? Colors.white60 : Colors.black54,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: dark_theme ? Colors.white : Colors.black,
          fixedSize: const Size(double.maxFinite, 59)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (loading)
            SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: dark_theme ? Colors.black : Colors.white,
                  backgroundColor: dark_theme ? Colors.black26 : Colors.white30,
                )),
          const Spacer(),
          Text(
            loading ? loading_label : label,
            style: AppTextStyles.regular(16,
                color: dark_theme ? Colors.black : Colors.white),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
