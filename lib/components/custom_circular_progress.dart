import "package:flutter/material.dart";

class CustomCircularProgress extends StatelessWidget {
  const CustomCircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: Colors.black,
              backgroundColor: Colors.black12,
            )));
  }
}
