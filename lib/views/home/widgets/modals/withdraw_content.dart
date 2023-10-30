import 'package:flutter/material.dart';

class WithdrawContent extends StatelessWidget {
  const WithdrawContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ))
          ],
          automaticallyImplyLeading: false,
          title: const Text('Retiradas'),
        ),
      ),
      body: const Column(children: []),
    );
  }
}
