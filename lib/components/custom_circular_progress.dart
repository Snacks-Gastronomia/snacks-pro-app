import "package:flutter/material.dart";

class CustomCircularProgress extends StatelessWidget {
  const CustomCircularProgress({super.key, this.dark = true});
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: dark ? Colors.black : Colors.white,
              backgroundColor: dark ? Colors.black12 : Colors.white12,
            )));
  }
}
